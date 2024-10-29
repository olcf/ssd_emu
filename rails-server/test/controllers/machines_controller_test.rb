require "test_helper"

class MachinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @machine = machines(:one)
  end

  test "should get index" do
    get machines_url, as: :json
    assert_response :success
  end

  test "should create machine" do
    assert_difference("Machine.count") do
      post machines_url, params: { machine: { cores: @machine.cores, cpus: @machine.cpus, gpus: @machine.gpus, modules_list: @machine.modules_list, name: @machine.name, nodes: @machine.nodes, storage: @machine.storage } }, as: :json
    end

    assert_response :created
  end

  test "should show machine" do
    get machine_url(@machine), as: :json
    assert_response :success
  end

  test "should update machine" do
    patch machine_url(@machine), params: { machine: { cores: @machine.cores, cpus: @machine.cpus, gpus: @machine.gpus, modules_list: @machine.modules_list, name: @machine.name, nodes: @machine.nodes, storage: @machine.storage } }, as: :json
    assert_response :success
  end

  test "should destroy machine" do
    assert_difference("Machine.count", -1) do
      delete machine_url(@machine), as: :json
    end

    assert_response :no_content
  end
end
