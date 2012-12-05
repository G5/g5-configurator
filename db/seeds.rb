RemoteApp.skip_callback(:create, :after, :create_instruction)
RemoteApp.client_app_creator
RemoteApp.set_callback(:create, :after, :create_instruction)
