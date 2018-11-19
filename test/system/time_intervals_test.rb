require "application_system_test_case"

class TimeIntervalsTest < ApplicationSystemTestCase
  setup do
    @time_interval = time_intervals(:one)
  end

  test "visiting the index" do
    visit time_intervals_url
    assert_selector "h1", text: "Time Intervals"
  end

  test "creating a Time interval" do
    visit time_intervals_url
    click_on "New Time Interval"

    fill_in "End Time", with: @time_interval.end_time
    fill_in "Name", with: @time_interval.name
    fill_in "Schema", with: @time_interval.schema_id
    fill_in "Start Time", with: @time_interval.start_time
    click_on "Create Time interval"

    assert_text "Time interval was successfully created"
    click_on "Back"
  end

  test "updating a Time interval" do
    visit time_intervals_url
    click_on "Edit", match: :first

    fill_in "End Time", with: @time_interval.end_time
    fill_in "Name", with: @time_interval.name
    fill_in "Schema", with: @time_interval.schema_id
    fill_in "Start Time", with: @time_interval.start_time
    click_on "Update Time interval"

    assert_text "Time interval was successfully updated"
    click_on "Back"
  end

  test "destroying a Time interval" do
    visit time_intervals_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Time interval was successfully destroyed"
  end
end
