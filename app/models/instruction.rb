class Instruction < ActiveRecord::Base
  NAMES = {
    RemoteApp::CLIENT_APP_CREATOR => "Create New App",
    RemoteApp::CLIENT_HUB_DEPLOYER => "Update Client Hub",
    RemoteApp::CLIENT_HUB => "Update Client Hub Deployer"
  }

  attr_accessible :target_app_kind, :target_app_ids, :remote_app_id, :body

  # the apps that should perform the instruction
  # explicit habtm
  has_many :instructions_target_apps
  has_many :target_apps, through: :instructions_target_apps, source: :target_app

  # the app that will be effected by the instruction
  # only needed for g5-client-app-creator instructions
  belongs_to :remote_app

  validates :target_app_kind,
    presence: true,
    inclusion: { in: RemoteApp::KINDS },
    allow_blank: true

  validates :remote_app_id,
    presence: true,
    if: :client_app_creator_kind?

  validate :has_at_least_one_target_app

  # webhooks make things speedy
  after_save :async_ping_target_apps

  def created_at_computer_readable
    created_at.utc.to_s(:computer)
  end

  def created_at_human_readable
    created_at.to_s(:human)
  end

  def name
    NAMES[target_app_kind]
  end

  private

  def client_app_creator_kind?
    target_app_kind == RemoteApp::CLIENT_APP_CREATOR
  end

  def has_at_least_one_target_app
    unless target_app_ids.length >= 1
      errors[:target_app_ids] = "can't be blank"
    end
  end

  def async_ping_target_apps
    Resque.enqueue(TargetAppPinger, self.id)
  end

  def ping_target_apps
    target_apps.pluck(:uid).each do |target_app_uid|
      begin
        Webhook.post("#{target_app_uid}/webhook")
      rescue ArgumentError => e
        logger.error e
      end
    end
  end
end
