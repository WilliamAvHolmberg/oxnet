require "application_system_test_case"

class TaskLogsTest < ApplicationSystemTestCase
  setup do
    @task_log = task_logs(:one)
  end

  test "visiting the index" do
    visit task_logs_url
    assert_selector "h1", text: "Task Logs"
  end

  test "creating a Task log" do
    visit task_logs_url
    click_on "New Task Log"

    fill_in "Account", with: @task_log.account_id
    fill_in "Money Per Hour", with: @task_log.money_per_hour
    fill_in "Position", with: @task_log.position
    fill_in "Respond", with: @task_log.respond
    fill_in "Task", with: @task_log.task_id
    fill_in "Xp Per Hour", with: @task_log.xp_per_hour
    click_on "Create Task log"

    assert_text "Task log was successfully created"
    click_on "Back"
  end

  test "updating a Task log" do
    visit task_logs_url
    click_on "Edit", match: :first

    fill_in "Account", with: @task_log.account_id
    fill_in "Money Per Hour", with: @task_log.money_per_hour
    fill_in "Position", with: @task_log.position
    fill_in "Respond", with: @task_log.respond
    fill_in "Task", with: @task_log.task_id
    fill_in "Xp Per Hour", with: @task_log.xp_per_hour
    click_on "Update Task log"

    assert_text "Task log was successfully updated"
    click_on "Back"
  end

  test "destroying a Task log" do
    visit task_logs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Task log was successfully destroyed"
  end
end
