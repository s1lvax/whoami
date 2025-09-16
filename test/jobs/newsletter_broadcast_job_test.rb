require "test_helper"

class NewsletterBroadcastJobTest < ActiveJob::TestCase
  fixtures :users
  include ActiveJob::TestHelper
  include ActionMailer::TestHelper

  def setup
    @user = users(:one)
    @post = Post.create!(
      user: @user,
      title: "Published Post",
      status: "published",
      send_to_newsletter: true,
      excerpt: "Job test excerpt"
    )
  end

  test "enqueues mail for each confirmed subscription" do
    @user.subscriptions.create!(subscriber_email: "sub1@example.com", confirmed: true, token: SecureRandom.hex(10))
    @user.subscriptions.create!(subscriber_email: "sub2@example.com", confirmed: true, token: SecureRandom.hex(10))

    assert_enqueued_emails 2 do
      NewsletterBroadcastJob.perform_now(@post.id)
    end
  end

  test "does nothing if post is draft" do
    draft = Post.create!(user: @user, title: "Draft", status: "draft", send_to_newsletter: true)

    assert_no_enqueued_emails do
      NewsletterBroadcastJob.perform_now(draft.id)
    end
  end

  test "does nothing if send_to_newsletter is false" do
    post = Post.create!(user: @user, title: "Published Post", status: "published", send_to_newsletter: false)

    assert_no_enqueued_emails do
      NewsletterBroadcastJob.perform_now(post.id)
    end
  end

  test "does nothing if already sent" do
    @post.update!(newsletter_sent: true)

    assert_no_enqueued_emails do
      NewsletterBroadcastJob.perform_now(@post.id)
    end
  end
end
