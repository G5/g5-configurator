class RenameColumnTargetToTargetAppIdOnInstructions < ActiveRecord::Migration
  def up
    remove_column :instructions, :target
    add_column :instructions, :target_app_id, :integer
  end

  def down
    remove_column :instructions, :target_app_id
    add_column :instructions, :target, :string
  end
end
