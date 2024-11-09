class AddUniquenessToProjectName < ActiveRecord::Migration[7.0]
  def change
    add_index :projects, :name, unique: true
  end
end
