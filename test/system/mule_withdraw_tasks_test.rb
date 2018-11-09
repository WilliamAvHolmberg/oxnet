require "application_system_test_case"

class MuleWithdrawTasksTest < ApplicationSystemTestCase
  setup do
    @mule_withdraw_task = mule_withdraw_tasks(:one)
  end

  test "visiting the index" do
    visit mule_withdraw_tasks_url
    assert_selector "h1", text: "Mule Withdraw Tasks"
  end

  test "creating a Mule withdraw task" do
    visit mule_withdraw_tasks_url
    click_on "New Mule Withdraw Task"

    fill_in "Account", with: @mule_withdraw_task.account_id
    fill_in "Area", with: @mule_withdraw_task.area_id
    fill_in "Executed", with: @mule_withdraw_task.executed
    fill_in "Item Amount", with: @mule_withdraw_task.item_amount
    fill_in "Item", with: @mule_withdraw_task.item_id
    fill_in "Name", with: @mule_withdraw_task.name
    fill_in "Slave Name", with: @mule_withdraw_task.slave_name
    fill_in "Task Type", with: @mule_withdraw_task.task_type_id
    fill_in "World", with: @mule_withdraw_task.world
    click_on "Create Mule withdraw task"

    assert_text "Mule withdraw task was successfully created"
    click_on "Back"
  end

  test "updating a Mule withdraw task" do
    visit mule_withdraw_tasks_url
    click_on "Edit", match: :first

    fill_in "Account", with: @mule_withdraw_task.account_id
    fill_in "Area", with: @mule_withdraw_task.area_id
    fill_in "Executed", with: @mule_withdraw_task.executed
    fill_in "Item Amount", with: @mule_withdraw_task.item_amount
    fill_in "Item", with: @mule_withdraw_task.item_id
    fill_in "Name", with: @mule_withdraw_task.name
    fill_in "Slave Name", with: @mule_withdraw_task.slave_name
    fill_in "Task Type", with: @mule_withdraw_task.task_type_id
    fill_in "World", with: @mule_withdraw_task.world
    click_on "Update Mule withdraw task"

    assert_text "Mule withdraw task was successfully updated"
    click_on "Back"
  end

  test "destroying a Mule withdraw task" do
    visit mule_withdraw_tasks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mule withdraw task was successfully destroyed"
  end
end
