require 'test_helper'

class RsWorldsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rs_world = rs_worlds(:one)
  end

  test "should get index" do
    get rs_worlds_url
    assert_response :success
  end

  test "should get new" do
    get new_rs_world_url
    assert_response :success
  end

  test "should create rs_world" do
    assert_difference('RsWorld.count') do
      post rs_worlds_url, params: { rs_world: { account: @rs_world.account, members_only: @rs_world.members_only, number: @rs_world.number } }
    end

    assert_redirected_to rs_world_url(RsWorld.last)
  end

  test "should show rs_world" do
    get rs_world_url(@rs_world)
    assert_response :success
  end

  test "should get edit" do
    get edit_rs_world_url(@rs_world)
    assert_response :success
  end

  test "should update rs_world" do
    patch rs_world_url(@rs_world), params: { rs_world: { account: @rs_world.account, members_only: @rs_world.members_only, number: @rs_world.number } }
    assert_redirected_to rs_world_url(@rs_world)
  end

  test "should destroy rs_world" do
    assert_difference('RsWorld.count', -1) do
      delete rs_world_url(@rs_world)
    end

    assert_redirected_to rs_worlds_url
  end
end
