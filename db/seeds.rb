RemoteApp.skip_callback(:create, :after, :create_instruction)
r      = RemoteApp.new
r.name = "g5-client-app-creator"
r.save
RemoteApp.set_callback(:create, :after, :create_instruction)
