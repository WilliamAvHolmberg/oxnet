require "application_system_test_case"

class MuleLogsTest < ApplicationSystemTestCase
  setup do
    @mule_log = mule_logs(:one)
  end

  test "visiting the index" do
    visit mule_logs_url
    assert_selector "h1", text: "Mule Logs"
  end

  test "creating a Mule log" do
    visit mule_logs_url
    click_on "New Mule Log"

    fill_in "Account", with: @mule_log.account_id
    fill_in "Item Amount", with: @mule_log.item_amount
    fill_in "Mule", with: @mule_log.mule
    click_on "Create Mule log"

    assert_text "Mule log was successfully created"
    click_on "Back"
  end

  test "updating a Mule log" do
    visit mule_logs_url
    click_on "Edit", match: :first

    fill_in "Account", with: @mule_log.account_id
    fill_in "Item Amount", with: @mule_log.item_amount
    fill_in "Mule", with: @mule_log.mule
    click_on "Update Mule log"

    assert_text "Mule log was successfully updated"
    click_on "Back"
  end

  test "destroying a Mule log" do
    visit mule_logs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mule log was successfully destroyed"
  end
end
