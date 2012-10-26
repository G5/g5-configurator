class AddTypeToRemoteApps < ActiveRecord::Migration
  def change
    add_column :remote_apps, :app_type, :string
  end
end
