class RemoteApp < ActiveRecord::Base
  CLIENT_APP_CREATOR_NAME = "g5-client-app-creator"
  CLIENT_APP_CREATOR_UID = "http://g5-client-app-creator.herokuapp.com"

  attr_accessible :uid, :client_uid, :name, :git_repo

  belongs_to :entry
  has_many :instructions

  validates :name, presence: true, uniqueness: true
  
  after_create :create_instruction
  
  def create_instruction
    self.instructions.create(target_app_id: client_app_creator.id)
  end
  
  private
  
  def client_app_creator
    self.class.client_app_creator
  end

  def self.client_app_creator
    @@client_app_creator ||= find_or_create_by_name(CLIENT_APP_CREATOR_NAME)
  end
end
