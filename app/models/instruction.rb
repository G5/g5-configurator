class Instruction < ActiveRecord::Base
  # the apps that should perform the instruction
  # explicit habtm
  has_many :instructions_target_apps
  has_many :target_apps, through: :instructions_target_apps, source: :target_app

  # the app that will be effected by the instruction
  # only needed for client-app-creator instructions
  belongs_to :remote_app

  validates :target_app_kind,
    presence: true,
    inclusion: { in: AppDefinition.all_kinds },
    allow_blank: true

  validates :remote_app_id,
    presence: true,
    if: :client_app_creator_kind?

  validate :has_at_least_one_target_app

  # webhooks make things speedy
  after_save :async_webhook_target_apps
  before_validation {|i| i.updated_app_kinds.reject!(&:empty?) }

  def created_at_computer_readable
    created_at.utc.to_s(:computer)
  end

  def created_at_human_readable
    created_at.to_s(:human)
  end

  def updated_at_computer_readable
    updated_at.utc.to_s(:computer)
  end

  def updated_at_human_readable
    updated_at.to_s(:human)
  end

  def name
    return nil if target_app_kind.nil?
    return "Create New App" if client_app_creator_kind?

    app_definition = AppDefinition.for_kind(target_app_kind)
    "Update #{app_definition.human_name} Siblings"
  end

  def async_webhook_target_apps
    Resque.enqueue(InstructionWebhooker, self.id)
  end

  def webhook_url
  end

  def webhook_target_apps
    target_apps.map(&:webhook)
  end

  def client_app_creator_kind?
    target_app_kind == CLIENT_APP_CREATOR_KIND
  end

  private

  def has_at_least_one_target_app
    unless target_app_ids.length >= 1
      errors[:target_app_ids] = "can't be blank"
    end
  end

end
