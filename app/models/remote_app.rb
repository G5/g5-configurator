class RemoteApp < ActiveRecord::Base
  CLIENT_APP_CREATOR  = "g5-client-app-creator"
  CLIENT_HUB_DEPLOYER = "g5-client-hub-deployer"
  CLIENT_HUB          = "g5-client-hub"
  KINDS           = [CLIENT_APP_CREATOR, CLIENT_HUB_DEPLOYER, CLIENT_HUB]
  PREFIXES = {
    CLIENT_HUB_DEPLOYER => "g5-chd-",
    CLIENT_HUB          => "g5-ch-"
  }
  REPOS = {
    CLIENT_APP_CREATOR  => "git@github.com:g5search/g5-client-app-creator.git",
    CLIENT_HUB_DEPLOYER => "git@github.com:g5search/g5-client-hub-deployer.git",
    CLIENT_HUB          => "git@github.com:g5search/g5-client-hub.git"
  }

  attr_accessible :entry_id, :kind, :client_uid, :client_name, :uid, :name, :git_repo

  belongs_to :entry

  # habtm
  has_many :instructions_target_apps, foreign_key: :target_app_id
  has_many :instructions, through: :instructions_target_apps

  validates :uid, presence: true, uniqueness: true
  validates :kind, presence: true, inclusion: { in: KINDS }

  before_validation :assign_missing_attributes
  after_create :create_instruction

  def self.grouped_by_kind_options
    KINDS.map do|kind| 
      [kind, RemoteApp.where(kind: kind).map {|app| [app.name, app.id] } ]
    end
  end

  private

  def assign_missing_attributes
    self.git_repo ||= REPOS[kind]
    self.name ||= "#{PREFIXES[kind]}#{client_name.parameterize}"
    self.uid ||= "http://#{name}.herokuapp.com"
  end

  def create_instruction
    self.instructions.create(target_app_kind: kind, target_app_ids: [client_app_creator.id])
  end

  def client_app_creator
    self.class.client_app_creator
  end

  def self.client_app_creator
    @@client_app_creator ||= find_or_create_by_kind(kind: CLIENT_APP_CREATOR, client_name: CLIENT_APP_CREATOR)
  end
end
