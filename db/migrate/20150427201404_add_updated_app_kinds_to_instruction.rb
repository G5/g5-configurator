class AddUpdatedAppKindsToInstruction < ActiveRecord::Migration
  def change
    add_column :instructions, :updated_app_kinds, :string, array: true, default: []
  end
end
