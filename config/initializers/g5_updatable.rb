G5Updatable::ClientUpdater.on_create do |g5_updatable_client|
  Entry.create_from_updatable_client(g5_updatable_client)
end
