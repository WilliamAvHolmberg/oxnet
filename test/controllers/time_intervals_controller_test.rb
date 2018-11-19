require 'test_helper'

class TimeIntervalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @time_interval = time_intervals(:one)
  end

  test "should get index" do
    get time_intervals_url
    assert_response :success
  end

  test "should get new" do
    get new_time_interval_url
    assert_response :success
  end

  test "should create time_interval" do
    assert_difference('TimeInterval.count') do
      post time_intervals_url, params: { time_interval: { end_time: @time_interval.end_time, name: @time_interval.name, schema_id: @time_interval.schema_id, start_time: @time_interval.start_time } }
    end

    assert_redirected_to time_interval_url(TimeInterval.last)
  end

  test "should show time_interval" do
    get time_interval_url(@time_interval)
    assert_response :success
  end

  test "should get edit" do
    get edit_time_interval_url(@time_interval)
    assert_response :success
  end

  test "should update time_interval" do
    patch time_interval_url(@time_interval), params: { time_interval: { end_time: @time_interval.end_time, name: @time_interval.name, schema_id: @time_interval.schema_id, start_time: @time_interval.start_time } }
    assert_redirected_to time_interval_url(@time_interval)
  end

  test "should destroy time_interval" do
    assert_difference('TimeInterval.count', -1) do
      delete time_interval_url(@time_interval)
    end

    assert_redirected_to time_intervals_url
  end
end
