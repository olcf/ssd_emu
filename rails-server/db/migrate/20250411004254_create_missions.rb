class CreateMissions < ActiveRecord::Migration[7.0]
  def change
    create_table :missions do |t|
      t.string :title
      t.text :content
      t.integer :difficulty_level
      t.boolean :is_completed

      t.timestamps
    end
  end
end
