class ChangedDefaultForStateAndJobReasonCodes < ActiveRecord::Migration[7.0]
  def change
    change_column_default :jobs, :job_reason_code, from: nil, to: 'None'
    change_column_default :jobs, :state, from: nil, to: 'NA'
  end
end
