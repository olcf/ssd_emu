class CreateMachines < ActiveRecord::Migration[7.0]
  def change
    create_table :machines do |t|
      t.string :name
      t.decimal :storage, precision: 12, scale: 2
      t.integer :cores
      t.integer :cpus
      t.integer :nodes
      t.integer :gpus
      t.json :modules_list
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
