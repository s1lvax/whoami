require "test_helper"

class Dashboard::SubscribersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :users

  setup do
    @user = users(:one)
    sign_in @user
    @subscription = @user.subscriptions.create!(
      subscriber_email: "reader@example.com",
      confirmed: true,
      confirmed_at: Time.current
    )
  end

  test "dashboard lists confirmed subscribers" do
    get dashboard_path
    assert_response :success
    assert_match "reader@example.com", response.body
  end

  test "owner can remove a subscriber" do
    assert_difference("@user.subscriptions.count", -1) do
      delete dashboard_subscriber_path(@subscription)
    end
    assert_redirected_to dashboard_path
  end

  test "cannot remove someone else's subscriber" do
    other = users(:two)
    other.update!(onboarded_at: Time.current)
    foreign = other.subscriptions.create!(subscriber_email: "nope@example.com", confirmed: true)

    assert_no_difference("Subscription.count") do
      delete dashboard_subscriber_path(foreign)
    end
    assert_response :not_found
  end
end
