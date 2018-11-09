require 'test_helper'

class MuleWithdrawTasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mule_withdraw_task = mule_withdraw_tasks(:one)
  end

  test "should get index" do
    get mule_withdraw_tasks_url
    assert_response :success
  end

  test "should get new" do
    get new_mule_withdraw_task_url
    assert_response :success
  end

  test "should create mule_withdraw_task" do
    assert_difference('MuleWithdrawTask.count') do
      post mule_withdraw_tasks_url, params: { mule_withdraw_task: { account_id: @mule_withdraw_task.account_id, area_id: @mule_withdraw_task.area_id, executed: @mule_withdraw_task.executed, item_amount: @mule_withdraw_task.item_amount, item_id: @mule_withdraw_task.item_id, name: @mule_withdraw_task.name, slave_name: @mule_withdraw_task.slave_name, task_type_id: @mule_withdraw_task.task_type_id, world: @mule_withdraw_task.world } }
    end

    assert_redirected_to mule_withdraw_task_url(MuleWithdrawTask.last)
  end

  test "should show mule_withdraw_task" do
    get mule_withdraw_task_url(@mule_withdraw_task)
    assert_response :success
  end

  test "should get edit" do
    get edit_mule_withdraw_task_url(@mule_withdraw_task)
    assert_response :success
  end

  test "should update mule_withdraw_task" do
    patch mule_withdraw_task_url(@mule_withdraw_task), params: { mule_withdraw_task: { account_id: @mule_withdraw_task.account_id, area_id: @mule_withdraw_task.area_id, executed: @mule_withdraw_task.executed, item_amount: @mule_withdraw_task.item_amount, item_id: @mule_withdraw_task.item_id, name: @mule_withdraw_task.name, slave_name: @mule_withdraw_task.slave_name, task_type_id: @mule_withdraw_task.task_type_id, world: @mule_withdraw_task.world } }
    assert_redirected_to mule_withdraw_task_url(@mule_withdraw_task)
  end

  test "should destroy mule_withdraw_task" do
    assert_difference('MuleWithdrawTask.count', -1) do
      delete mule_withdraw_task_url(@mule_withdraw_task)
    end

    assert_redirected_to mule_withdraw_tasks_url
  end
end
