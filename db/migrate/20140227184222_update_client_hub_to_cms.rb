class UpdateClientHubToCms < ActiveRecord::Migration
  def up
    RemoteApp.where(kind: "client-hub").each do |app|
      app.name = app.send(:assign_name)
      app.kind = "content-management-system"
      app.save
    end
  end

  def down
  end
end
