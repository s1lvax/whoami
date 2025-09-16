require "test_helper"

class SubscriptionControllerTest < ActionDispatch::IntegrationTest
  test "should get subscribe" do
    get subscription_subscribe_url
    assert_response :success
  end

  test "should get confirm" do
    get subscription_confirm_url
    assert_response :success
  end

  test "should get cancel" do
    get subscription_cancel_url
    assert_response :success
  end
end
