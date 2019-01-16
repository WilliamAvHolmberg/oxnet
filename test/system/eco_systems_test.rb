require "application_system_test_case"

class EcoSystemsTest < ApplicationSystemTestCase
  setup do
    @eco_system = eco_systems(:one)
  end

  test "visiting the index" do
    visit eco_systems_url
    assert_selector "h1", text: "Eco Systems"
  end

  test "creating a Eco system" do
    visit eco_systems_url
    click_on "New Eco System"

    fill_in "Accounts", with: @eco_system.accounts
    fill_in "Computers", with: @eco_system.computers
    fill_in "Proxies", with: @eco_system.proxies
    click_on "Create Eco system"

    assert_text "Eco system was successfully created"
    click_on "Back"
  end

  test "updating a Eco system" do
    visit eco_systems_url
    click_on "Edit", match: :first

    fill_in "Accounts", with: @eco_system.accounts
    fill_in "Computers", with: @eco_system.computers
    fill_in "Proxies", with: @eco_system.proxies
    click_on "Update Eco system"

    assert_text "Eco system was successfully updated"
    click_on "Back"
  end

  test "destroying a Eco system" do
    visit eco_systems_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Eco system was successfully destroyed"
  end
end
