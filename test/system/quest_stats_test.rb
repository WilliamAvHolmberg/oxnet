require "application_system_test_case"

class QuestStatsTest < ApplicationSystemTestCase
  setup do
    @quest_stat = quest_stats(:one)
  end

  test "visiting the index" do
    visit quest_stats_url
    assert_selector "h1", text: "Quest Stats"
  end

  test "creating a Quest stat" do
    visit quest_stats_url
    click_on "New Quest Stat"

    fill_in "Account", with: @quest_stat.account_id
    fill_in "Completed", with: @quest_stat.completed
    fill_in "Quest", with: @quest_stat.quest_id
    click_on "Create Quest stat"

    assert_text "Quest stat was successfully created"
    click_on "Back"
  end

  test "updating a Quest stat" do
    visit quest_stats_url
    click_on "Edit", match: :first

    fill_in "Account", with: @quest_stat.account_id
    fill_in "Completed", with: @quest_stat.completed
    fill_in "Quest", with: @quest_stat.quest_id
    click_on "Update Quest stat"

    assert_text "Quest stat was successfully updated"
    click_on "Back"
  end

  test "destroying a Quest stat" do
    visit quest_stats_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Quest stat was successfully destroyed"
  end
end
