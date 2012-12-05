class CreateInstructionsTargetApps < ActiveRecord::Migration
  def change
    create_table :instructions_target_apps do |t|
      t.integer :instruction_id
      t.integer :target_app_id

      t.timestamps
    end
  end
end
