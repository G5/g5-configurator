class RemoteApp < ActiveRecord::Base
  attr_accessible :name
  validates :name, uniqueness: true
  before_destroy :delete_remote_app
  belongs_to :entry
  has_many :instructions, foreign_key: :deployer_id
  # {"name":"luna-sandals","released_at":"2012/10/04 16:05:10 -0700","repo_migrate_status":"complete","create_status":"complete","requested_stack":null,"stack":"bamboo-mri-1.9.2","slug_size":46575616,"created_at":"2010/06/14 11:40:07 -0700","updated_at":"2012/10/05 10:34:55 -0700","buildpack_provided_description":"Ruby/Rails","git_url":"git@heroku.com:luna-sandals.git","owner_name":null,"id":211652,"database_size":null,"owner_email":"vegan.bookis@gmail.com","repo_size":154157056,"web_url":"http://luna-sandals.heroku.com/","domain_name":{"default":true,"base_domain":"heroku.com","created_at":null,"updated_at":null,"app_id":211652,"domain":"luna-sandals.heroku.com","id":null},"dynos":2,"workers":0}
  
  def app
    heroku.get_app(canonical_name)
  end
  
  def mock?
    heroku.as_json["connection"].connection[:mock]
  end
  
  def canonical_name
    "g5-client-deployer-" + name
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
