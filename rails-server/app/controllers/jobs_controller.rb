class JobsController < ApplicationController
  before_action :set_job, only: %i[ show update destroy ]

  # GET /jobs
  def index
    query_parameters = request.query_parameters;
    # REVIEW: Ask on SSD group for efficient and correct way to do this and update this code.
    if query_parameters["machine_id"] != nil
      @jobs = Job.select("jobs.*,projects.name as project_name").
      joins("INNER JOIN projects on projects.id = jobs.project_id").where(machine_id: query_parameters["machine_id"]);
    else
      @jobs = Job.select("jobs.*,projects.name as project_name").joins("INNER JOIN projects on projects.id = jobs.project_id")
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
      params.require(:job).permit(:project_name, :nodes, :walltime, :cores, :mail_type, :mail_user, :state, :job_reason_code, :script, :out, :err, :machine_id, :user_id)
    end
end