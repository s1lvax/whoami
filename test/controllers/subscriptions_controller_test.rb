require "test_helper"

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  include ActionCable::TestHelper
  fixtures :users

  setup do
    @user = users(:one)
  end

  test "should create subscription and send confirmation email" do
    assert_enqueued_emails 1 do
      post new_subscription_path(username: @user.username), params: {
        subscription: { subscriber_email: "test@example.com" }
      }
    end

    assert_redirected_to subscription_sent_path(username: @user.username)
    assert Subscription.exists?(subscriber_email: "test@example.com", user: @user)
  end

  test "should not create duplicate subscription" do
    @user.subscriptions.create!(subscriber_email: "dupe@example.com")

    assert_no_difference "Subscription.count" do
      post new_subscription_path(username: @user.username), params: {
        subscription: { subscriber_email: "dupe@example.com" }
      }
    end

    assert_redirected_to subscription_sent_path(username: @user.username)
  end

  test "should confirm subscription and send welcome email" do
    subscription = @user.subscriptions.create!(subscriber_email: "confirm@example.com")

    assert_enqueued_emails 1 do
      get confirm_subscription_path(username: @user.username, token: subscription.token)
    end

    assert_redirected_to public_profile_path(@user.username)
    assert subscription.reload.confirmed
  end

  test "should not confirm with invalid token" do
    get confirm_subscription_path(username: @user.username, token: "wrongtoken")

    assert_redirected_to subscription_sent_path(username: @user.username)
    assert_equal "Something went wrong. Please try again.", flash[:alert]
  end

  test "should cancel subscription and send unsubscribe email" do
    subscription = @user.subscriptions.create!(subscriber_email: "bye@example.com", confirmed: true)

    assert_enqueued_emails 1 do
      get cancel_subscription_path(username: @user.username, token: subscription.token)
    end

    assert_redirected_to public_profile_path(@user.username)
    refute Subscription.exists?(id: subscription.id)
  end

  test "should handle cancel with invalid token" do
    get cancel_subscription_path(username: @user.username, token: "wrongtoken")

    assert_redirected_to public_profile_path(@user.username)
    assert_equal "This subscription is no longer valid.", flash[:alert]
  end

  test "subscribing from a post swaps the form in place and waits for the confirmation" do
    post new_subscription_path(username: @user.username),
         params: { subscription: { subscriber_email: "inplace@example.com" }, variant: "card" },
         as: :turbo_stream

    assert_response :success
    token = Subscription.find_by!(subscriber_email: "inplace@example.com").token
    assert_match %r{<turbo-stream action="replace" target="subscribe-card">}, response.body
    assert_match "Check your inbox", response.body
    assert_match "turbo-cable-stream-source", response.body
    assert_match "subscription-status-#{token}", response.body
  end

  test "an invalid email re-renders the form with the error in place" do
    post new_subscription_path(username: @user.username),
         params: { subscription: { subscriber_email: "" }, variant: "inline" },
         as: :turbo_stream

    assert_response :success
    assert_match %r{<turbo-stream action="replace" target="subscribe-inline">}, response.body
    assert_match "subscribe-inline-form", response.body
  end

  test "confirming broadcasts the confirmed state to the waiting page" do
    subscription = @user.subscriptions.create!(subscriber_email: "wait@example.com")

    assert_broadcasts("subscription:#{subscription.token}", 1) do
      get confirm_subscription_path(username: @user.username, token: subscription.token)
    end
    assert subscription.reload.confirmed
  end
end
