class RemoteApp < ActiveRecord::Base
  HEROKU_APP_NAME_MAX_LENGTH = 30

  belongs_to :entry

  # habtm
  has_many :instructions_target_apps, foreign_key: :target_app_id
  has_many :instructions, through: :instructions_target_apps, source: :instruction

  validates :kind, presence: true, inclusion: { in: AppDefinition.all_kinds }
  validates :client_uid, presence: true, unless: :non_client_app?
  validates :name, presence: true, uniqueness: true

  before_validation :assign_name
  after_create :create_instruction

  def self.grouped_by_kind_options
    AppDefinition.all_kinds.map do |kind|
      [kind, RemoteApp.where(kind: kind).map {|app| [app.name, app.id] } ]
    end
  end

  def client_urn
    @client_urn ||= client_uid.split("/").last
  end

  def client_id
    @client_id ||= client_urn.split("-").third
  end

  def git_repo
    @git_repo ||= app_definition.repo_url
  end

  def heroku_app_name
    name_formatter.send("#{app_definition.prefix}_app_name")
  end

  def heroku_repo
    @heroku_repo ||= "git@heroku.com:#{heroku_app_name}.git"
  end

  def heroku_url
    @heroku_url ||= "http://#{heroku_app_name}.herokuapp.com"
  end

  def siblings
    RemoteApp.where("id != ?", id).where(client_uid: client_uid)
  end

  def to_param
    name
  end

  def webhook_host
    ENV["G5_REMOTE_APP_WEBHOOK_HOST"]
  end

  def webhook_url
    "http://#{heroku_app_name}.#{webhook_host}/webhooks/g5-configurator"
  end

  def webhook
    Webhook.post(webhook_url)
  rescue ArgumentError => e
    Rails.logger.error e
  end

  private

  def app_definition
    @app_definition ||= AppDefinition.for_kind(kind)
  end

  def assign_name
    self.name ||= if non_client_app?
      with_orion_namespace(kind)
    elsif client_name
      formatter = G5HerokuAppNameFormatter::Formatter.new(client_urn,
                                                          app_definition.prefix)
      formatter.send("#{app_definition.prefix}_app_name")
    end
  end

  def with_orion_namespace(s)
    "#{ENV["APP_NAMESPACE"]}-#{s}"
  end

  def non_client_app?
    app_definition.non_client?
  end

  def create_instruction
    Rails.logger.info("Creating instruction in remote_app")
    Instruction.create(
      target_app_kind: client_app_creator.kind,
      target_app_ids: [client_app_creator.id],
      remote_app_id: self.id
    )
  end

  def client_app_creator
    self.class.client_app_creator
  end

  def name_formatter
    @name_formatter ||= G5HerokuAppNameFormatter::Formatter.new(client_urn, app_definition.prefix)
  end

  def self.client_app_creator
    find_by_kind(CLIENT_APP_CREATOR_KIND)
  end

  def self.client_app_creator_deployer
    find_by_kind(CLIENT_APP_CREATOR_DEPLOYER_KIND)
  end
end
