class RemoveProjectNameColumnAndAddProjectId < ActiveRecord::Migration[7.0]
  def change
    remove_column :jobs, :project_name
    add_column :jobs, :project_id, :integer, index: true
    add_foreign_key :jobs, :projects, column: :project_id
  end
end
