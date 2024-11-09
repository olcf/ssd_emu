class AddNewColumnsOnJob < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :name, :string
    add_column :jobs, :out_file, :string, default: nil
    add_column :jobs, :err_file, :string, default: nil
    add_column :jobs, :slurm_cores, :integer, default: 8
  end
end
