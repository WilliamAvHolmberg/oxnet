require "application_system_test_case"

class ConfigurationsTest < ApplicationSystemTestCase
  setup do
    @configuration = configurations(:one)
  end

  test "visiting the index" do
    visit configurations_url
    assert_selector "h1", text: "Configurations"
  end

  test "creating a Configuration" do
    visit configurations_url
    click_on "New Configuration"

    fill_in "Computer", with: @configuration.computer_id
    fill_in "Use creation server", with: @configuration.use_creation_server
    click_on "Create Configuration"

    assert_text "Configuration was successfully created"
    click_on "Back"
  end

  test "updating a Configuration" do
    visit configurations_url
    click_on "Edit", match: :first

    fill_in "Computer", with: @configuration.computer_id
    fill_in "Use creation server", with: @configuration.use_creation_server
    click_on "Update Configuration"

    assert_text "Configuration was successfully updated"
    click_on "Back"
  end

  test "destroying a Configuration" do
    visit configurations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Configuration was successfully destroyed"
  end
end
