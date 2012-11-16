class AddRepoToRemoteApps < ActiveRecord::Migration
  def change
    add_column :remote_apps, :git_repo, :string
  end
end
