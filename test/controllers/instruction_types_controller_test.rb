require 'test_helper'

class InstructionTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @instruction_type = instruction_types(:one)
  end

  test "should get index" do
    get instruction_types_url
    assert_response :success
  end

  test "should get new" do
    get new_instruction_type_url
    assert_response :success
  end

  test "should create instruction_type" do
    assert_difference('InstructionType.count') do
      post instruction_types_url, params: { instruction_type: { name: @instruction_type.name } }
    end

    assert_redirected_to instruction_type_url(InstructionType.last)
  end

  test "should show instruction_type" do
    get instruction_type_url(@instruction_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_instruction_type_url(@instruction_type)
    assert_response :success
  end

  test "should update instruction_type" do
    patch instruction_type_url(@instruction_type), params: { instruction_type: { name: @instruction_type.name } }
    assert_redirected_to instruction_type_url(@instruction_type)
  end

  test "should destroy instruction_type" do
    assert_difference('InstructionType.count', -1) do
      delete instruction_type_url(@instruction_type)
    end

    assert_redirected_to instruction_types_url
  end
end
