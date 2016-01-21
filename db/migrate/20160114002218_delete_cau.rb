class DeleteCau < ActiveRecord::Migration
  def change
    RemoteApp.where(kind: "client-app-updater").destroy_all
  end
end
