class AddHerokuRepoAndAppNameToRemoteApps < ActiveRecord::Migration
  def change
    add_column :remote_apps, :heroku_app_name, :string
    rename_column :remote_apps, :uid, :heroku_url
  end
end
