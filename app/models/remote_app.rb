class RemoteApp < ActiveRecord::Base
  attr_accessible :name, :git_repo
  validates :name, presence: true, uniqueness: true
  belongs_to :entry
  has_many :instructions, foreign_key: :remote_app_id
  after_create :create_instruction
  
  def create_instruction
    self.class.client_app_creator.instructions.create(body: instruction_body)
  end
  
  def instruction_body
    "<p class='p-name'>#{truncated_name}</p><a class='u-url u-uid' href='#{git_repo}'>#{git_repo}</a>"
  end
  
  def app_url
    "http://#{truncated_name}.herokuapp.com"
  end
  
  private
  
  def self.client_app_creator
    where(name: "g5-client-app-creator").first
  end
  
  def truncated_name
    name[0,24]
  end
  
end
