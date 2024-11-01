class AddingUniqueMachineNameForUniqueUser < ActiveRecord::Migration[7.0]
  def change
    add_index :machines, [:name, :user_id], unique: true
  end
end
