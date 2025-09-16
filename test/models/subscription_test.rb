require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  fixtures :users

  def setup
    @user       = users(:one)
    @other_user = users(:two)
  end

  test "is valid with a subscriber_email and user" do
    subscription = @user.subscriptions.new(subscriber_email: "test@example.com")
    assert subscription.valid?
  end

  test "is invalid without a subscriber_email" do
    subscription = @user.subscriptions.new(subscriber_email: nil)
    refute subscription.valid?
    assert_includes subscription.errors[:subscriber_email], "can't be blank"
  end

  test "does not allow duplicate emails per user" do
    @user.subscriptions.create!(subscriber_email: "dupe@example.com")
    dup = @user.subscriptions.new(subscriber_email: "dupe@example.com")

    refute dup.valid?
    assert_includes dup.errors[:subscriber_email], "is already subscribed"
  end

  test "allows same email to subscribe to different users" do
    @user.subscriptions.create!(subscriber_email: "same@example.com")
    subscription = @other_user.subscriptions.new(subscriber_email: "same@example.com")

    assert subscription.valid?
  end

  test "confirmed scope returns only confirmed subscriptions" do
    confirmed   = @user.subscriptions.create!(subscriber_email: "confirmed@example.com", confirmed: true)
    unconfirmed = @user.subscriptions.create!(subscriber_email: "pending@example.com", confirmed: false)

    assert_includes Subscription.confirmed, confirmed
    refute_includes Subscription.confirmed, unconfirmed
  end

  test "token is generated automatically" do
    subscription = @user.subscriptions.create!(subscriber_email: "token@example.com")
    assert subscription.token.present?
  end
end
