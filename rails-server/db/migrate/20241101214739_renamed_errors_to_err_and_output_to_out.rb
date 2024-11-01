# Rails doesn't allow having errors as column name as it is used in many other places. There is hack to solve it but I wanted to change it to err (output for out just for uniformity) so that it won't be confusing about which error are we talking about 
class RenamedErrorsToErrAndOutputToOut < ActiveRecord::Migration[7.0]
  def change
    rename_column :jobs, :output, :out
    rename_column :jobs, :errors, :err
  end
end
