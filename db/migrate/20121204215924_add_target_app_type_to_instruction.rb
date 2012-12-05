class AddTargetAppTypeToInstruction < ActiveRecord::Migration
  def change
    add_column :instructions, :target_app_type, :string
  end
end
