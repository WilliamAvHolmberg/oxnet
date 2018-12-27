require 'test_helper'

class HiscoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hiscore = hiscores(:one)
  end

  test "should get index" do
    get hiscores_url
    assert_response :success
  end

  test "should get new" do
    get new_hiscore_url
    assert_response :success
  end

  test "should create hiscore" do
    assert_difference('Hiscore.count') do
      post hiscores_url, params: { hiscore: { skill_id: @hiscore.skill_id } }
    end

    assert_redirected_to hiscore_url(Hiscore.last)
  end

  test "should show hiscore" do
    get hiscore_url(@hiscore)
    assert_response :success
  end

  test "should get edit" do
    get edit_hiscore_url(@hiscore)
    assert_response :success
  end

  test "should update hiscore" do
    patch hiscore_url(@hiscore), params: { hiscore: { skill_id: @hiscore.skill_id } }
    assert_redirected_to hiscore_url(@hiscore)
  end

  test "should destroy hiscore" do
    assert_difference('Hiscore.count', -1) do
      delete hiscore_url(@hiscore)
    end

    assert_redirected_to hiscores_url
  end
end
