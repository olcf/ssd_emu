class JobsController < ApplicationController
  before_action :set_job, only: %i[ show update destroy ]

  # GET /jobs
  def index
    query_parameters = request.query_parameters;
    if query_parameters["machine_id"] != nil
      @jobs = Job.joins(:project).where(machine_id: query_parameters["machine_id"]).select("jobs.*,projects.name as project_name").offset(5)
    else
      @jobs = Job.joins(:project).select("jobs.*,projects.name as project_name").offset(5)
    end



    render json: @jobs
  end

  # GET /jobs/1
  def show
    render json: @job
  end

  # POST /jobs
  def create
    @job = Job.new(job_params)

    if @job.save
      render json: @job, status: :created, location: @job
    else
      render json: @job.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /jobs/1
  def update
    if @job.update(job_params)
      render json: @job
    else
      render json: @job.errors, status: :unprocessable_entity
    end
  end

  # requested is considered as job
  # available is considered as machine to check with
  def invalid_job_machine_available_generator(property,requested_job,available)
    return "User requested #{requested_job[property]} #{property} but, the requested machine '#{available.name}' only has #{available[property]} #{property}. Make sure you are not requesting #{property} more than your machine have.\n"
  end
  # PATCH /jobs/run/1
  def run
    user_id = job_params["user_id"]
    job_id = params["id"]
    job = Job.joins(:project).select("jobs.*,projects.name as project_name").where(id:job_id,user_id:user_id).first
    if !job.nil?
      # If job passes all the requirements(number of nodes, cpu, etc from the requested machine configuration.)
      
      # Checking if given script is allowed to run
      machine_requested = job.machine
      errors = ""

      if job.nodes >= machine_requested.nodes
        errors += invalid_job_machine_available_generator("nodes",job,machine_requested)
      end
      if job.cores >= machine_requested.cores
        errors += invalid_job_machine_available_generator("cores",job,machine_requested)
      end

      if errors.length >0
        job.state = "CA" #Canceled
        job.job_reason_code = "ReqNodeNotAvail"
        job.out = nil
        job.err = errors
        job.save
      else
        job.state = "PD" #Pending
        job.save
        # Perform when all the queue of current job is free.
        RunUserJobInDockerJob.perform_later(params["id"])
      end

      render json: job
      
    else
      render json:{"exception":"Can't find job with given information for your user."}, status: :unprocessable_entity
    end
  end
  
  # DELETE /jobs/1
  def destroy
    @job.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      # we are using first method since where will return array of jobs
      @job = Job.joins(:project).select("jobs.*,projects.name as project_name").where(id:params[:id]).first
    end

    # Only allow a list of trusted parameters through.
    def job_params
      params.require(:job).permit(:name, :project_id, :nodes, :walltime, :cores, :slurm_cores, :mail_type, :mail_user, :state, :job_reason_code, :script, :out, :out_file, :err, :err_file, :machine_id, :user_id)
    end
end
