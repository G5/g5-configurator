class CreateInstructions < ActiveRecord::Migration
  def self.up
    create_table :instructions do |t|
      t.string :target
      t.text :body
      t.integer :deployer_id
      t.timestamps
    end
    add_index :instructions, :deployer_id
  end

  def self.down
    remove_index :instructions, :deployer_id
    drop_table :instructions
  end
end