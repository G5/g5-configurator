RemoteApp.skip_callback(:create, :after, :create_instruction)
RemoteApp.create(kind: CLIENT_APP_CREATOR_KIND)
RemoteApp.create(kind: CLIENT_APP_CREATOR_DEPLOYER_KIND)
RemoteApp.set_callback(:create, :after, :create_instruction)
