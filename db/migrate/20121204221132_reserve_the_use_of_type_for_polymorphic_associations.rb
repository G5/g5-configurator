class ReserveTheUseOfTypeForPolymorphicAssociations < ActiveRecord::Migration
  def up
    rename_column :remote_apps, :app_type, :kind
    rename_column :instructions, :target_app_type, :target_app_kind
  end

  def down
    rename_column :instructions, :target_app_kind, :target_app_type
    rename_column :remote_apps, :kind, :app_type
  end
end
