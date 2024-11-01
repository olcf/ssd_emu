class RenamedErrorsToErrAndOutputToOut < ActiveRecord::Migration[7.0]
  def change
    rename_column :jobs, :output, :out
    rename_column :jobs, :errors, :err
  end
end
