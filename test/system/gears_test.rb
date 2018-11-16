require "application_system_test_case"

class GearsTest < ApplicationSystemTestCase
  setup do
    @gear = gears(:one)
  end

  test "visiting the index" do
    visit gears_url
    assert_selector "h1", text: "Gears"
  end

  test "creating a Gear" do
    visit gears_url
    click_on "New Gear"

    fill_in "Ammunition", with: @gear.ammunition
    fill_in "Ammunition Amount", with: @gear.ammunition_amount
    fill_in "Cape", with: @gear.cape
    fill_in "Feet", with: @gear.feet
    fill_in "Hands", with: @gear.hands
    fill_in "Head", with: @gear.head
    fill_in "Legs", with: @gear.legs
    fill_in "Neck", with: @gear.neck
    fill_in "Ring", with: @gear.ring
    fill_in "Shield", with: @gear.shield
    fill_in "Weapon", with: @gear.weapon
    click_on "Create Gear"

    assert_text "Gear was successfully created"
    click_on "Back"
  end

  test "updating a Gear" do
    visit gears_url
    click_on "Edit", match: :first

    fill_in "Ammunition", with: @gear.ammunition
    fill_in "Ammunition Amount", with: @gear.ammunition_amount
    fill_in "Cape", with: @gear.cape
    fill_in "Feet", with: @gear.feet
    fill_in "Hands", with: @gear.hands
    fill_in "Head", with: @gear.head
    fill_in "Legs", with: @gear.legs
    fill_in "Neck", with: @gear.neck
    fill_in "Ring", with: @gear.ring
    fill_in "Shield", with: @gear.shield
    fill_in "Weapon", with: @gear.weapon
    click_on "Update Gear"

    assert_text "Gear was successfully updated"
    click_on "Back"
  end

  test "destroying a Gear" do
    visit gears_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Gear was successfully destroyed"
  end
end
