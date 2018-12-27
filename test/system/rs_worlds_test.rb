require "application_system_test_case"

class RsWorldsTest < ApplicationSystemTestCase
  setup do
    @rs_world = rs_worlds(:one)
  end

  test "visiting the index" do
    visit rs_worlds_url
    assert_selector "h1", text: "Rs Worlds"
  end

  test "creating a Rs world" do
    visit rs_worlds_url
    click_on "New Rs World"

    fill_in "Account", with: @rs_world.account
    fill_in "Members only", with: @rs_world.members_only
    fill_in "Number", with: @rs_world.number
    click_on "Create Rs world"

    assert_text "Rs world was successfully created"
    click_on "Back"
  end

  test "updating a Rs world" do
    visit rs_worlds_url
    click_on "Edit", match: :first

    fill_in "Account", with: @rs_world.account
    fill_in "Members only", with: @rs_world.members_only
    fill_in "Number", with: @rs_world.number
    click_on "Update Rs world"

    assert_text "Rs world was successfully updated"
    click_on "Back"
  end

  test "destroying a Rs world" do
    visit rs_worlds_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Rs world was successfully destroyed"
  end
end
