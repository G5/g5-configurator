class Instruction < ActiveRecord::Base
  NAMES = {
    RemoteApp::CLIENT_APP_CREATOR => "Create New App",
    RemoteApp::CLIENT_HUB_DEPLOYER => "Update Client Hub",
    RemoteApp::CLIENT_HUB => "Update Client Hub Deployer",
    RemoteApp::CLIENT_APP_CREATOR_DEPLOYER => "Update Client App Creator"
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
  after_save :async_webhook_target_apps

  def created_at_computer_readable
    created_at.utc.to_s(:computer)
  end

  def created_at_human_readable
    created_at.to_s(:human)
  end

  def name
    NAMES[target_app_kind]
  end

  def async_webhook_target_apps
    Resque.enqueue(InstructionWebhooker, self.id)
  end

  def webhook_target_apps
    target_apps.pluck(:heroku_app_name).each do |heroku_app_name|
      begin
        Webhook.post("http://#{heroku_app_name}.herokuapp.com/webhooks/g5-configurator")
      rescue ArgumentError => e
        logger.error e
      end
    end
  end

  def client_app_creator_kind?
    target_app_kind == RemoteApp::CLIENT_APP_CREATOR
  end

  private

  def has_at_least_one_target_app
    unless target_app_ids.length >= 1
      errors[:target_app_ids] = "can't be blank"
    end
  end
end
