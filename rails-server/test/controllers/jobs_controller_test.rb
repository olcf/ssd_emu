require "test_helper"

class JobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @job = jobs(:one)
  end

  test "should get index" do
    get jobs_url, as: :json
    assert_response :success
  end

  test "should create job" do
    assert_difference("Job.count") do
      post jobs_url, params: { job: { cores: @job.cores, errors: @job.errors, job_reason_code: @job.job_reason_code, machine_id: @job.machine_id, mail_type: @job.mail_type, mail_user: @job.mail_user, nodes: @job.nodes, output: @job.output, project_name: @job.project_name, script: @job.script, state: @job.state, user_id: @job.user_id, walltime: @job.walltime } }, as: :json
    end

    assert_response :created
  end

  test "should show job" do
    get job_url(@job), as: :json
    assert_response :success
  end

  test "should update job" do
    patch job_url(@job), params: { job: { cores: @job.cores, errors: @job.errors, job_reason_code: @job.job_reason_code, machine_id: @job.machine_id, mail_type: @job.mail_type, mail_user: @job.mail_user, nodes: @job.nodes, output: @job.output, project_name: @job.project_name, script: @job.script, state: @job.state, user_id: @job.user_id, walltime: @job.walltime } }, as: :json
    assert_response :success
  end

  test "should destroy job" do
    assert_difference("Job.count", -1) do
      delete job_url(@job), as: :json
    end

    assert_response :no_content
  end
end
