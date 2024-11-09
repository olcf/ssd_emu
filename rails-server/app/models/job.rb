class Job < ApplicationRecord
  belongs_to :machine
  belongs_to :user
  belongs_to :project
  
  
  # all of job reason codes are from frontier docs. None means it has not been run/ created
  VALID_JOB_REASON_CODES = ["Dependency","JobHeldUser","JobHeldAdmin","Priority","Reservation","AssocMaxJobsLimit","ReqNodeNotAvail","JobLaunchFailure","NonZeroExitCode","None"]

  # all of these states are from frontier docs. NA means the none of them / not applicable (when job is only created and not run)
  VALID_JOB_STATES = ['CA', 'CD','CG', 'PD','R','NA']
  validates :state, inclusion: { in: Job::VALID_JOB_STATES, :message => "Value %{value} is not a valid state"}
  validates :job_reason_code, inclusion: { in: Job::VALID_JOB_REASON_CODES, :message => "Value %{value} is not a valid job reason code" }

  # TODO: Add validation for Mail type 
  # Send email for certain job actions. Can be a comma-separated list. Actions include BEGIN, END, FAIL, REQUEUE, INVALID_DEPEND, STAGE_OUT, ALL, and more.
   

end
