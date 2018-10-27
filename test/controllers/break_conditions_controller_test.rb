require 'test_helper'

class BreakConditionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @break_condition = break_conditions(:one)
  end

  test "should get index" do
    get break_conditions_url
    assert_response :success
  end

  test "should get new" do
    get new_break_condition_url
    assert_response :success
  end

  test "should create break_condition" do
    assert_difference('BreakCondition.count') do
      post break_conditions_url, params: { break_condition: { name: @break_condition.name } }
    end

    assert_redirected_to break_condition_url(BreakCondition.last)
  end

  test "should show break_condition" do
    get break_condition_url(@break_condition)
    assert_response :success
  end

  test "should get edit" do
    get edit_break_condition_url(@break_condition)
    assert_response :success
  end

  test "should update break_condition" do
    patch break_condition_url(@break_condition), params: { break_condition: { name: @break_condition.name } }
    assert_redirected_to break_condition_url(@break_condition)
  end

  test "should destroy break_condition" do
    assert_difference('BreakCondition.count', -1) do
      delete break_condition_url(@break_condition)
    end

    assert_redirected_to break_conditions_url
  end
end
