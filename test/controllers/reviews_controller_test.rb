require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get reviews_index_url
    assert_response :success
  end

  test "should get show" do
    get reviews_show_url
    assert_response :success
  end

  test "should get edit" do
    get reviews_edit_url
    assert_response :success
  end

  test "should get update" do
    get reviews_update_url
    assert_response :success
  end

  test "should get respond" do
    get reviews_respond_url
    assert_response :success
  end
end
