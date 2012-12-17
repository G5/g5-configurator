RemoteApp.skip_callback(:create, :after, :create_instruction)
RemoteApp.create(kind: RemoteApp::CLIENT_APP_CREATOR)
RemoteApp.set_callback(:create, :after, :create_instruction)
