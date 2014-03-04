class UpdateClientHubDeployerToClientAppUpdater < ActiveRecord::Migration
  def up
    RemoteApp.where(kind: "client-hub-deployer").each do |app|
      app.kind = "client-app-updater"
      app.name = nil
      app.name = app.send(:assign_name)
      app.save
    end
  end

  def down
  end
end
