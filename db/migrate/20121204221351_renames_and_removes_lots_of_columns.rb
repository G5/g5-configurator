class RenamesAndRemovesLotsOfColumns < ActiveRecord::Migration
  def up
    rename_column :entries, :bookmark, :uid
    remove_column :entries, :name
    remove_column :entries, :summary
    remove_column :entries, :content
    remove_column :entries, :published_at

    remove_column :instructions, :body
    remove_column :instructions, :target_app_id

    remove_column :remote_apps, :app_id
    remove_column :remote_apps, :create_status
    remove_column :remote_apps, :configuration
    add_column :remote_apps, :client_name, :string
  end

  def down
    remove_column :remote_apps, :client_name
    add_column :remote_apps, :configuration, :text
    add_column :remote_apps, :create_status, :string, default: :pending
    add_column :remote_apps, :app_id, :integer

    add_column :instructions, :target_app_id, :integer
    add_column :instructions, :body, :text

    add_column :entries, :published_at, :datetime
    add_column :entries, :content, :text
    add_column :entries, :summary, :string
    add_column :entries, :name, :string
    rename_column :entries, :uid, :bookmark
  end
end
