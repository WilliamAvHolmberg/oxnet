require "application_system_test_case"

class InstructionTypesTest < ApplicationSystemTestCase
  setup do
    @instruction_type = instruction_types(:one)
  end

  test "visiting the index" do
    visit instruction_types_url
    assert_selector "h1", text: "Instruction Types"
  end

  test "creating a Instruction type" do
    visit instruction_types_url
    click_on "New Instruction Type"

    fill_in "Name", with: @instruction_type.name
    click_on "Create Instruction type"

    assert_text "Instruction type was successfully created"
    click_on "Back"
  end

  test "updating a Instruction type" do
    visit instruction_types_url
    click_on "Edit", match: :first

    fill_in "Name", with: @instruction_type.name
    click_on "Update Instruction type"

    assert_text "Instruction type was successfully updated"
    click_on "Back"
  end

  test "destroying a Instruction type" do
    visit instruction_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Instruction type was successfully destroyed"
  end
end
