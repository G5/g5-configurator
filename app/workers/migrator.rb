class Migrator
  @queue = :migrator
  def self.perform(remote_app_id)
    remote = RemoteApp.find(remote_app_id)
    remote.migrate
  end
end
