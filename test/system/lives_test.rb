require "application_system_test_case"

class LivesTest < ApplicationSystemTestCase
  setup do
    @life = lives(:one)
  end

  test "visiting the index" do
    visit lives_url
    assert_selector "h1", text: "Lives"
  end

  test "creating a Live" do
    visit lives_url
    click_on "New Live"

    click_on "Create Live"

    assert_text "Live was successfully created"
    click_on "Back"
  end

  test "updating a Live" do
    visit lives_url
    click_on "Edit", match: :first

    click_on "Update Live"

    assert_text "Live was successfully updated"
    click_on "Back"
  end

  test "destroying a Live" do
    visit lives_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Live was successfully destroyed"
  end
end
