require 'test_helper'

class MuleLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mule_log = mule_logs(:one)
  end

  test "should get index" do
    get mule_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_mule_log_url
    assert_response :success
  end

  test "should create mule_log" do
    assert_difference('MuleLog.count') do
      post mule_logs_url, params: { mule_log: { account_id: @mule_log.account_id, item_amount: @mule_log.item_amount, mule: @mule_log.mule } }
    end

    assert_redirected_to mule_log_url(MuleLog.last)
  end

  test "should show mule_log" do
    get mule_log_url(@mule_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_mule_log_url(@mule_log)
    assert_response :success
  end

  test "should update mule_log" do
    patch mule_log_url(@mule_log), params: { mule_log: { account_id: @mule_log.account_id, item_amount: @mule_log.item_amount, mule: @mule_log.mule } }
    assert_redirected_to mule_log_url(@mule_log)
  end

  test "should destroy mule_log" do
    assert_difference('MuleLog.count', -1) do
      delete mule_log_url(@mule_log)
    end

    assert_redirected_to mule_logs_url
  end
end
