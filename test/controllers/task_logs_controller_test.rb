require 'test_helper'

class TaskLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @task_log = task_logs(:one)
  end

  test "should get index" do
    get task_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_task_log_url
    assert_response :success
  end

  test "should create task_log" do
    assert_difference('TaskLog.count') do
      post task_logs_url, params: { task_log: { account_id: @task_log.account_id, money_per_hour: @task_log.money_per_hour, position: @task_log.position, respond: @task_log.respond, task_id: @task_log.task_id, xp_per_hour: @task_log.xp_per_hour } }
    end

    assert_redirected_to task_log_url(TaskLog.last)
  end

  test "should show task_log" do
    get task_log_url(@task_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_task_log_url(@task_log)
    assert_response :success
  end

  test "should update task_log" do
    patch task_log_url(@task_log), params: { task_log: { account_id: @task_log.account_id, money_per_hour: @task_log.money_per_hour, position: @task_log.position, respond: @task_log.respond, task_id: @task_log.task_id, xp_per_hour: @task_log.xp_per_hour } }
    assert_redirected_to task_log_url(@task_log)
  end

  test "should destroy task_log" do
    assert_difference('TaskLog.count', -1) do
      delete task_log_url(@task_log)
    end

    assert_redirected_to task_logs_url
  end
end
