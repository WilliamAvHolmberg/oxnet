require "application_system_test_case"

class BreakConditionsTest < ApplicationSystemTestCase
  setup do
    @break_condition = break_conditions(:one)
  end

  test "visiting the index" do
    visit break_conditions_url
    assert_selector "h1", text: "Break Conditions"
  end

  test "creating a Break condition" do
    visit break_conditions_url
    click_on "New Break Condition"

    fill_in "Name", with: @break_condition.name
    click_on "Create Break condition"

    assert_text "Break condition was successfully created"
    click_on "Back"
  end

  test "updating a Break condition" do
    visit break_conditions_url
    click_on "Edit", match: :first

    fill_in "Name", with: @break_condition.name
    click_on "Update Break condition"

    assert_text "Break condition was successfully updated"
    click_on "Back"
  end

  test "destroying a Break condition" do
    visit break_conditions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Break condition was successfully destroyed"
  end
end
