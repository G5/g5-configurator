class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :bookmark, :name, :summary
      t.text :content
      t.datetime :published_at
      t.timestamps
    end
  end
end
