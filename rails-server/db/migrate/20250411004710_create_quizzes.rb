class CreateQuizzes < ActiveRecord::Migration[7.0]
  def change
    create_table :quizzes do |t|
      t.references :chapter, null: false, foreign_key: true
      t.text :question
      t.string :question_type
      t.jsonb :options
      t.integer :correct_option_index
      t.text :explanation

      t.timestamps
    end
  end
end
