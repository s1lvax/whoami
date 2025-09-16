require "test_helper"

class SubscriptionMailerTest < ActionMailer::TestCase
  fixtures :users

  def setup
    @user = users(:one)
    @token = "sometoken123"
    @email = "subscriber@example.com"
  end

  test "confirm" do
    mail = SubscriptionMailer.with(
      token: @token,
      username: @user.username,
      email: @email
    ).confirm

    assert_emails 1 do
      mail.deliver_now
    end

    assert_equal [ "subscriber@example.com" ], mail.to
    assert_equal "Confirm your new subscription to #{@user.username}", mail.subject
    assert_match @token, mail.body.encoded
    assert_match @user.username, mail.body.encoded
  end

  test "welcome" do
    mail = SubscriptionMailer.with(
      token: @token,
      username: @user.username,
      email: @email
    ).welcome

    assert_emails 1 do
      mail.deliver_now
    end

    assert_equal [ "subscriber@example.com" ], mail.to
    assert_equal "Your subscription to #{@user.username}", mail.subject
    assert_match @user.username, mail.body.encoded
  end

  test "unsubscribe" do
    mail = SubscriptionMailer.with(
      username: @user.username,
      email: @email
    ).unsubscribe

    assert_emails 1 do
      mail.deliver_now
    end

    assert_equal [ "subscriber@example.com" ], mail.to
    assert_equal "You unsubscribed from #{@user.username}", mail.subject
    assert_match @user.username, mail.body.encoded
  end
end
