RemoteApp.skip_callback(:create, :after, :create_instruction)
RemoteApp.find_or_create_by_name(RemoteApp::CLIENT_APP_CREATOR_NAME) do |app|
  app.uid = RemoteApp::CLIENT_APP_CREATOR_UID
end
RemoteApp.set_callback(:create, :after, :create_instruction)
