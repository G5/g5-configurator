class UpdateClientHubToCms < ActiveRecord::Migration
  def up
    RemoteApp.where(kind: "client-hub").each do |app|
      app.kind = "content-management-system"
      app.name = nil
      app.name = app.send(:assign_name)
      app.save
    end
  end

  def down
  end
end
