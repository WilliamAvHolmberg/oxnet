require "application_system_test_case"

class RsItemsTest < ApplicationSystemTestCase
  setup do
    @rs_item = rs_items(:one)
  end

  test "visiting the index" do
    visit rs_items_url
    assert_selector "h1", text: "Rs Items"
  end

  test "creating a Rs item" do
    visit rs_items_url
    click_on "New Rs Item"

    fill_in "item_id", with: @rs_item.item_id
    fill_in "item_name", with: @rs_item.item_name
    click_on "Create Rs item"

    assert_text "Rs item was successfully created"
    click_on "Back"
  end

  test "updating a Rs item" do
    visit rs_items_url
    click_on "Edit", match: :first

    fill_in "item_id", with: @rs_item.item_id
    fill_in "item_name", with: @rs_item.item_name
    click_on "Update Rs item"

    assert_text "Rs item was successfully updated"
    click_on "Back"
  end

  test "destroying a Rs item" do
    visit rs_items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Rs item was successfully destroyed"
  end
end
