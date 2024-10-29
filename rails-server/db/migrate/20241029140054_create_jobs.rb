class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.string :projectName
      t.integer :nodes
      t.integer :walltime
      t.integer :cores
      t.string :mail_type
      t.string :mail_user
      t.string :state
      t.string :job_reason_code
      t.text :script
      t.text :output
      t.text :errors
      t.references :machine, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
