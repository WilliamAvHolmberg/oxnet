require "application_system_test_case"

class HiscoresTest < ApplicationSystemTestCase
  setup do
    @hiscore = hiscores(:one)
  end

  test "visiting the index" do
    visit hiscores_url
    assert_selector "h1", text: "Hiscores"
  end

  test "creating a Hiscore" do
    visit hiscores_url
    click_on "New Hiscore"

    fill_in "Skill", with: @hiscore.skill_id
    click_on "Create Hiscore"

    assert_text "Hiscore was successfully created"
    click_on "Back"
  end

  test "updating a Hiscore" do
    visit hiscores_url
    click_on "Edit", match: :first

    fill_in "Skill", with: @hiscore.skill_id
    click_on "Update Hiscore"

    assert_text "Hiscore was successfully updated"
    click_on "Back"
  end

  test "destroying a Hiscore" do
    visit hiscores_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hiscore was successfully destroyed"
  end
end
