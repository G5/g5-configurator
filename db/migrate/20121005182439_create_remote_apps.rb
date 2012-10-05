class CreateRemoteApps < ActiveRecord::Migration
  def change
    create_table :remote_apps do |t|
      t.integer :app_id, :entry_id
      t.string :name, :web_url
      t.string :create_status, default: 'pending'
      t.text :configuration
      
      t.timestamps
    end
  end
end
