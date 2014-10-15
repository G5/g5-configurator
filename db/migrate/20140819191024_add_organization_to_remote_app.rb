class AddOrganizationToRemoteApp < ActiveRecord::Migration
  def change
    add_column :remote_apps, :organization, :string
  end
end
