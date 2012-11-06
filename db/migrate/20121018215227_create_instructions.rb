class CreateInstructions < ActiveRecord::Migration
  def self.up
    create_table :instructions do |t|
      t.string :target
      t.text :body
      t.integer :remote_app_id
      t.timestamps
    end
  end

  def self.down
    drop_table :instructions
  end
end