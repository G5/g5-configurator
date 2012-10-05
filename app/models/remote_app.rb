class RemoteApp < ActiveRecord::Base
  attr_accessible :name
  validates :name, uniqueness: true
  # {"name":"luna-sandals","released_at":"2012/10/04 16:05:10 -0700","repo_migrate_status":"complete","create_status":"complete","requested_stack":null,"stack":"bamboo-mri-1.9.2","slug_size":46575616,"created_at":"2010/06/14 11:40:07 -0700","updated_at":"2012/10/05 10:34:55 -0700","buildpack_provided_description":"Ruby/Rails","git_url":"git@heroku.com:luna-sandals.git","owner_name":null,"id":211652,"database_size":null,"owner_email":"vegan.bookis@gmail.com","repo_size":154157056,"web_url":"http://luna-sandals.heroku.com/","domain_name":{"default":true,"base_domain":"heroku.com","created_at":null,"updated_at":null,"app_id":211652,"domain":"luna-sandals.heroku.com","id":null},"dynos":2,"workers":0}
  
  def app
    heroku.get_app(name)
  end
  
  def mock?
    heroku.as_json["connection"].connection[:mock]
  end
  
  def spin_up
    response = heroku.post_app(name: name)
    create_from_response(response)
  rescue Heroku::API::Errors::RequestFailed => e
    self.errors[:base] = JSON.parse(e.response.body)["error"]
    false
  end
  
  private
  
  def create_from_response(response)
    self.web_url       = response.body["web_url"]
    self.create_status = response.body["create_status"]
    self.save
  end
  
  def heroku
    Heroku::API.new
  end
end
