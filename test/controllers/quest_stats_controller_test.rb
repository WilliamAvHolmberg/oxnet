require 'test_helper'

class QuestStatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quest_stat = quest_stats(:one)
  end

  test "should get index" do
    get quest_stats_url
    assert_response :success
  end

  test "should get new" do
    get new_quest_stat_url
    assert_response :success
  end

  test "should create quest_stat" do
    assert_difference('QuestStat.count') do
      post quest_stats_url, params: { quest_stat: { account_id: @quest_stat.account_id, completed: @quest_stat.completed, quest_id: @quest_stat.quest_id } }
    end

    assert_redirected_to quest_stat_url(QuestStat.last)
  end

  test "should show quest_stat" do
    get quest_stat_url(@quest_stat)
    assert_response :success
  end

  test "should get edit" do
    get edit_quest_stat_url(@quest_stat)
    assert_response :success
  end

  test "should update quest_stat" do
    patch quest_stat_url(@quest_stat), params: { quest_stat: { account_id: @quest_stat.account_id, completed: @quest_stat.completed, quest_id: @quest_stat.quest_id } }
    assert_redirected_to quest_stat_url(@quest_stat)
  end

  test "should destroy quest_stat" do
    assert_difference('QuestStat.count', -1) do
      delete quest_stat_url(@quest_stat)
    end

    assert_redirected_to quest_stats_url
  end
end
