class RemoteApp < ActiveRecord::Base
  class AppTypeError < RuntimeError; end
  attr_accessible :name, :app_type
  validates :name, uniqueness: true
  validates :app_type, presence: true
  before_destroy :delete_remote_app
  belongs_to :entry
  has_many :instructions, foreign_key: :deployer_id
  
  def app
    heroku.get_app(canonical_name)
  end
  
  def canonical_name
    prefix = case self.app_type
    when "ClientDeployer" then "g5-cd-"
    when "ClientHub"      then "g5-ch-"
    else
      raise AppTypeError, "Unrecongnized App Type"
    end
    prefix + truncated_name
  end
  
  def spin_up
    response = heroku.post_app(name: canonical_name)
    create_from_response(response)
    add_addon('deployhooks:http', url: "https://g5-configurator.herokuapp.com/remote_apps/#{self.id}/migrate")
  rescue Heroku::API::Errors::RequestFailed => e
    self.errors[:base] = JSON.parse(e.response.body)["error"]
    false
  end
  
  def migrate
    heroku.post_ps(canonical_name, 'rake db:migrate') 
  end
  
  def add_addon(addon, options={})
    heroku.post_addon(canonical_name, addon, options)
  end
  
  def delete_addon(addon)
    heroku.delete_addon(canonical_name, addon)
  end
  
  private
  
  def truncated_name
    name[0,24]
  end
  
  def create_from_response(response)
    self.web_url       = response.body["web_url"]
    self.create_status = response.body["create_status"]
    if self.save
      Resque.enqueue(Deployer, self.id)
    end
  end
  
  def delete_remote_app
    heroku.delete_app(canonical_name)
  end
  
  def heroku
    Heroku::API.new
  end
end
