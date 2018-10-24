require 'test_helper'

class RsItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rs_item = rs_items(:one)
  end

  test "should get index" do
    get rs_items_url
    assert_response :success
  end

  test "should get new" do
    get new_rs_item_url
    assert_response :success
  end

  test "should create rs_item" do
    assert_difference('RsItem.count') do
      post rs_items_url, params: { rs_item: { itemId: @rs_item.itemId, itemName: @rs_item.itemName } }
    end

    assert_redirected_to rs_item_url(RsItem.last)
  end

  test "should show rs_item" do
    get rs_item_url(@rs_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_rs_item_url(@rs_item)
    assert_response :success
  end

  test "should update rs_item" do
    patch rs_item_url(@rs_item), params: { rs_item: { itemId: @rs_item.itemId, itemName: @rs_item.itemName } }
    assert_redirected_to rs_item_url(@rs_item)
  end

  test "should destroy rs_item" do
    assert_difference('RsItem.count', -1) do
      delete rs_item_url(@rs_item)
    end

    assert_redirected_to rs_items_url
  end
end
