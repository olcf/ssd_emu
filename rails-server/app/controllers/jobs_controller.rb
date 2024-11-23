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

  # PATCH /jobs/run/1
  def run
    user_id = job_params["user_id"]
    job_id = params["id"]
    job = Job.where(id: job_id, user_id: user_id).first
    if !job.nil?
      # Perform when all the queue of current job is free.
      RunUserJobInDockerJob.perform_later(params["id"])
      
      render json: {status:"running"}
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
      @job = Job.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def job_params
      params.require(:job).permit(:name, :project_id, :nodes, :walltime, :cores, :slurm_cores, :mail_type, :mail_user, :state, :job_reason_code, :script, :out, :out_file, :err, :err_file, :machine_id, :user_id)
    end
end
