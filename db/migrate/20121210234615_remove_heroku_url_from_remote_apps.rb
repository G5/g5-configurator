class RemoveHerokuUrlFromRemoteApps < ActiveRecord::Migration
  def up
    remove_column :remote_apps, :heroku_url
  end

  def down
    add_column :remote_apps, :heroku_url, :string
  end
end
