class AddClientUidToRemoteApps < ActiveRecord::Migration
  def change
    add_column :remote_apps, :client_uid, :string
  end
end
