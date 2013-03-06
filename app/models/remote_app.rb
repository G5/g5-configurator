class RemoteApp < ActiveRecord::Base

  CLIENT_APP_CREATOR          = "g5-client-app-creator"
  CLIENT_APP_CREATOR_DEPLOYER = "g5-client-app-creator-deployer"

  CLIENT_HUB                  = "g5-client-hub"
  CLIENT_HUB_DEPLOYER         = "g5-client-hub-deployer"

  CLIENT_LEADS_SERVICE         = "g5-client-lead-service"

  KINDS           = [CLIENT_APP_CREATOR, CLIENT_HUB_DEPLOYER, CLIENT_HUB, CLIENT_APP_CREATOR_DEPLOYER, CLIENT_LEADS_SERVICE]

  PREFIXES = {
    CLIENT_HUB_DEPLOYER => "g5-chd-",
    CLIENT_HUB          => "g5-ch-"
  }

  REPOS = {
    CLIENT_APP_CREATOR          => "git@github.com:g5search/g5-client-app-creator.git",
    CLIENT_APP_CREATOR_DEPLOYER => "git@github.com:g5search/g5-sibling-deployer.git",
    CLIENT_HUB                  => "git@github.com:g5search/g5-client-hub.git",
    CLIENT_HUB_DEPLOYER         => "git@github.com:g5search/g5-client-hub-deployer.git",
    CLIENT_LEADS_SERVICE        => "git@github.com:g5search/g5-client-leads-service.git"
  }

  attr_accessible :entry_id, :client_uid, :client_name
  attr_accessible :kind, :name, :git_repo, :heroku_app_name

  belongs_to :entry

  # habtm
  has_many :instructions_target_apps, foreign_key: :target_app_id
  has_many :instructions, through: :instructions_target_apps, source: :instruction

  validates :kind, presence: true, inclusion: { in: KINDS }
  validates :client_uid, presence: true, unless: :non_client_app?
  validates :client_name, presence: true, unless: :non_client_app?
  validates :name, presence: true, uniqueness: true
  validates :heroku_app_name, presence: true, uniqueness: true
  validates :git_repo, presence: true

  before_validation :assign_missing_attributes
  after_create :create_instruction

  def self.grouped_by_kind_options
    KINDS.map do|kind|
      [kind, RemoteApp.where(kind: kind).map {|app| [app.name, app.id] } ]
    end
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

  private

  def non_client_app?
    self.kind.in? [CLIENT_APP_CREATOR, CLIENT_APP_CREATOR_DEPLOYER]
  end

  def assign_missing_attributes
    assign_git_repo
    assign_heroku_app_name
    assign_name
  end

  def assign_git_repo
    self.git_repo ||= REPOS[kind]
  end

  def assign_heroku_app_name
    if non_client_app?
      self.heroku_app_name ||= kind
    else
      self.heroku_app_name ||= "#{PREFIXES[kind]}#{client_name.parameterize}" if client_name
    end
  end

  def assign_name
    self.name ||= heroku_app_name
  end

  def create_instruction
    Instruction.create(
      target_app_kind: client_app_creator.kind,
      target_app_ids: [client_app_creator.id],
      remote_app_id: self.id
    )
  end

  def client_app_creator
    self.class.client_app_creator
  end

  def self.client_app_creator
    find_by_kind(CLIENT_APP_CREATOR)
  end

  def self.client_app_creator_deployer
    find_by_kind(CLIENT_APP_CREATOR_DEPLOYER)
  end

end
