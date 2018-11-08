require "application_system_test_case"

class AccountTypesTest < ApplicationSystemTestCase
  setup do
    @account_type = account_types(:one)
  end

  test "visiting the index" do
    visit account_types_url
    assert_selector "h1", text: "Account Types"
  end

  test "creating a Account type" do
    visit account_types_url
    click_on "New Account Type"

    fill_in "Name", with: @account_type.name
    click_on "Create Account type"

    assert_text "Account type was successfully created"
    click_on "Back"
  end

  test "updating a Account type" do
    visit account_types_url
    click_on "Edit", match: :first

    fill_in "Name", with: @account_type.name
    click_on "Update Account type"

    assert_text "Account type was successfully updated"
    click_on "Back"
  end

  test "destroying a Account type" do
    visit account_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Account type was successfully destroyed"
  end
end
