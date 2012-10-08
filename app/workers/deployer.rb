class Deployer
  DEPLOYER_URL="http://app-pusher.herokuapp.com/force-push"
  GITHUB_REPO = "https://github.com/bookis/vanilla.git"
  @queue = :deployer
  
  def self.perform(remote_app_id)
    remote = RemoteApp.find(remote_app_id)
    request = Typhoeus::Request.get(DEPLOYER_URL, params: {heroku_repo: remote.app.body["git_url"], github_repo: GITHUB_REPO})
  end
  
end
