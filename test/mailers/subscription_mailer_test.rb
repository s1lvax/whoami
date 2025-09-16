require "test_helper"

class SubscriptionMailerTest < ActionMailer::TestCase
  fixtures :users

  def setup
    @user  = users(:one)
    @token = "sometoken123"
    @email = "subscriber@example.com"
    @post  = Post.create!(
      user: @user,
      title: "Broadcast Title",
      status: "published",
      excerpt: "Sample excerpt",
      body: "This is the body of the broadcast post"
    )
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

  test "broadcast_post" do
    mail = SubscriptionMailer.with(
      post: @post,
      token: @token,
      username: @user.username,
      email: @email
    ).broadcast_post

    assert_emails 1 do
      mail.deliver_now
    end

    assert_equal [ "subscriber@example.com" ], mail.to
    assert_equal "#{@user.username} just published: #{@post.title}", mail.subject
    assert_match @post.body.to_plain_text, mail.body.encoded
    assert_match @token, mail.body.encoded
    assert_match @user.username, mail.body.encoded
    assert_match "View this post online", mail.body.encoded
    assert_match "Unsubscribe", mail.body.encoded
  end
end
