require "test_helper"

class PostTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  fixtures :users

  def setup
    @user = users(:one)
  end

  def build_post(attrs = {})
    Post.new({
      user: @user,
      title: "Hello World",
      status: "draft",
      excerpt: "Sample excerpt"
    }.merge(attrs))
  end

  # --- validations -----------------------------------------------------------

  test "valid post saves" do
    post = build_post
    assert post.valid?, -> { post.errors.full_messages.inspect }
  end

  test "title is required" do
    post = build_post(title: "")
    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
  end

  test "title cannot exceed 120 chars" do
    post = build_post(title: "a" * 121)
    assert_not post.valid?
    assert_includes post.errors[:title], "is too long (maximum is 120 characters)"
  end

  test "status must be draft or published" do
    post = build_post(status: "invalid")
    assert_not post.valid?
    assert_includes post.errors[:status], "is not included in the list"
  end

  test "status defaults to draft" do
    post = Post.new(user: @user, title: "Defaults")
    assert_equal "draft", post.status
  end

  # --- callbacks -------------------------------------------------------------

  test "trim_fields strips whitespace" do
    post = build_post(title: "  Spaced Out  ", excerpt: "  Trim me  ")
    post.validate
    assert_equal "Spaced Out", post.title
    assert_equal "Trim me", post.excerpt
  end

  test "trim_fields handles nil gracefully" do
    post = build_post(title: nil, excerpt: nil)
    post.validate
    assert_equal "", post.title
    assert_equal "", post.excerpt
  end

  test "sync_published_at sets timestamp when publishing" do
    post = build_post(status: "published", published_at: nil)
    assert_nil post.published_at
    post.save!
    assert_not_nil post.published_at
  end

  test "sync_published_at clears published_at when reverting to draft" do
    post = build_post(status: "published")
    post.save!
    assert post.published_at.present?

    post.update!(status: "draft")
    assert_nil post.published_at
  end

  # --- scopes & methods ------------------------------------------------------

  test "published? returns true for published" do
    assert build_post(status: "published").published?
    assert_not build_post(status: "draft").published?
  end

  test "latest scope orders by published_at or updated_at desc" do
    older = build_post(title: "Older Post Title", status: "published")
    older.save!
    sleep 0.1
    newer = build_post(title: "Newer Post Title", status: "published")
    newer.save!

    list = Post.latest.to_a
    # Our two freshly created posts should be the first two in order
    assert_equal [ newer, older ], list.first(2)
  end

  test "published scope only returns published posts" do
    draft = build_post(status: "draft"); draft.save!
    pub   = build_post(status: "published"); pub.save!
    assert_includes Post.published, pub
    assert_not_includes Post.published, draft
  end

  test "should_generate_new_friendly_id? when title changes" do
    post = build_post
    post.save!
    post.title = "Changed"
    assert post.should_generate_new_friendly_id?
  end

  test "should_generate_new_friendly_id? is false if title unchanged" do
    post = build_post
    post.save!
    refute post.should_generate_new_friendly_id?
  end

  # --- body attachments ------------------------------------------------------

  test "rejects non-image attachments" do
    post = build_post
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new("hello"),
      filename: "file.txt",
      content_type: "text/plain"
    )
    post.body = ActionText::Content.new(
      "<action-text-attachment sgid='#{blob.attachable_sgid}'></action-text-attachment>"
    )
    assert_not post.valid?
    assert_includes post.errors[:body].join, "must be images"
  end

  test "rejects oversized image attachments" do
    post = build_post
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new("0" * (Post::MAX_IMAGE_SIZE + 1)),
      filename: "big.jpg",
      content_type: "image/jpeg"
    )
    post.body = ActionText::Content.new(
      "<action-text-attachment sgid='#{blob.attachable_sgid}'></action-text-attachment>"
    )
    assert_not post.valid?
    assert_includes post.errors[:body].join, "smaller than"
  end

  test "rejects too many pixels" do
    post = build_post
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new("fake"),
      filename: "huge.jpg",
      content_type: "image/jpeg"
    )
    blob.update!(metadata: { width: 10_000, height: 3_000 })

    post.body = ActionText::Content.new(
      "<action-text-attachment sgid='#{blob.attachable_sgid}'></action-text-attachment>"
    )
    assert_not post.valid?
    assert_includes post.errors[:body].join, "too large"
  end

  test "accepts valid image attachment" do
    post = build_post
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new("img"),
      filename: "ok.jpg",
      content_type: "image/jpeg",
      metadata: { width: 100, height: 100 }
    )
    post.body = ActionText::Content.new(
      "<action-text-attachment sgid='#{blob.attachable_sgid}'></action-text-attachment>"
    )
    assert post.valid?, -> { post.errors.full_messages.inspect }
  end

  # --- newsletter broadcast --------------------------------------------------

  test "does not enqueue newsletter for draft" do
    post = build_post(send_to_newsletter: true, status: "draft")
    assert_no_enqueued_jobs only: NewsletterBroadcastJob do
      post.save!
    end
  end

  test "does not enqueue newsletter if send_to_newsletter is false" do
    post = build_post(status: "published", send_to_newsletter: false)
    assert_no_enqueued_jobs only: NewsletterBroadcastJob do
      post.save!
    end
  end

  test "does not enqueue newsletter if no confirmed subscriptions" do
    post = build_post(status: "published", send_to_newsletter: true)
    assert_no_enqueued_jobs only: NewsletterBroadcastJob do
      post.save!
    end
  end

  test "enqueues newsletter when published, send_to_newsletter true, and confirmed subscriptions exist" do
    @user.subscriptions.create!(
      subscriber_email: "test@example.com",
      confirmed: true,
      confirmed_at: Time.current
    )
    post = build_post(status: "published", send_to_newsletter: true)

    assert_enqueued_jobs 1, only: NewsletterBroadcastJob do
      post.save!
    end
  end

  test "does not enqueue newsletter again if already sent" do
    @user.subscriptions.create!(
      subscriber_email: "test@example.com",
      confirmed: true,
      confirmed_at: Time.current
    )
    post = build_post(status: "published", send_to_newsletter: true, newsletter_sent: true)

    assert_no_enqueued_jobs only: NewsletterBroadcastJob do
      post.save!
    end
  end
end
