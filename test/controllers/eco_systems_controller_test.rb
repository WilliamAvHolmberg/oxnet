require 'test_helper'

class EcoSystemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @eco_system = eco_systems(:one)
  end

  test "should get index" do
    get eco_systems_url
    assert_response :success
  end

  test "should get new" do
    get new_eco_system_url
    assert_response :success
  end

  test "should create eco_system" do
    assert_difference('EcoSystem.count') do
      post eco_systems_url, params: { eco_system: { accounts: @eco_system.accounts, computers: @eco_system.computers, proxies: @eco_system.proxies } }
    end

    assert_redirected_to eco_system_url(EcoSystem.last)
  end

  test "should show eco_system" do
    get eco_system_url(@eco_system)
    assert_response :success
  end

  test "should get edit" do
    get edit_eco_system_url(@eco_system)
    assert_response :success
  end

  test "should update eco_system" do
    patch eco_system_url(@eco_system), params: { eco_system: { accounts: @eco_system.accounts, computers: @eco_system.computers, proxies: @eco_system.proxies } }
    assert_redirected_to eco_system_url(@eco_system)
  end

  test "should destroy eco_system" do
    assert_difference('EcoSystem.count', -1) do
      delete eco_system_url(@eco_system)
    end

    assert_redirected_to eco_systems_url
  end
end
