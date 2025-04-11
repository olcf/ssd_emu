class CreateChapters < ActiveRecord::Migration[7.0]
  def change
    create_table :chapters do |t|
      t.references :mission, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.integer :position

      t.timestamps
    end
  end
end
