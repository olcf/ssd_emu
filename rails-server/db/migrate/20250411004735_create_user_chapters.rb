class CreateUserChapters < ActiveRecord::Migration[7.0]
  def change
    create_table :user_chapters do |t|
      t.references :user, null: false, foreign_key: true
      t.references :chapter, null: false, foreign_key: true
      t.boolean :completed
      t.datetime :completed_at

      t.timestamps
    end
  end
end
