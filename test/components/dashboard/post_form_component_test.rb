# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class Dashboard::PostFormComponentTest < ViewComponent::TestCase
  # ---------- helpers ----------
  def build_user(attrs = {})
    User.create!(
      email: "user#{SecureRandom.hex(3)}@example.com",
      password: "Password!123",
      password_confirmation: "Password!123",
      username: "user#{SecureRandom.hex(2)}",
      confirmed_at: Time.current,
      **attrs
    )
  end

  def build_persisted_post
    user = (users(:one) rescue nil) || build_user
    Post.create!(
      user: user,
      title: "Persisted Title",
      excerpt: "Persisted Excerpt",
      status: :draft
    )
  end

  def render_fragment(post:, submit_path:, submit_method:)
    html = render_inline(
      Dashboard::PostFormComponent.new(
        post: post,
        submit_path: submit_path,
        submit_method: submit_method,
        cancel_path: "/dashboard"
      )
    ).to_html
    Nokogiri::HTML.fragment(html)
  end
  # --------------------------------
  #
  test "renders the newsletter checkbox when the author has confirmed subscribers" do
    post = build_persisted_post
    post.user.subscriptions.create!(subscriber_email: "reader@example.com", confirmed: true)
    frag = render_fragment(post: post, submit_path: "/dashboard/posts/#{post.slug}", submit_method: :patch)

    assert frag.at_css(%(input[type="checkbox"][name="post[send_to_newsletter]"]))
    assert_includes frag.text, "1 subscriber"
    assert_nil frag.at_css("[data-controller=clipboard]")
  end

  test "without subscribers it explains and offers to copy the page link" do
    post = build_persisted_post
    post.user.subscriptions.destroy_all
    frag = render_fragment(post: post, submit_path: "/dashboard/posts/#{post.slug}", submit_method: :patch)

    assert_nil frag.at_css(%(input[name="post[send_to_newsletter]"][type="checkbox"]))
    assert_includes frag.text, "No subscribers yet"
    share = frag.at_css("[data-controller=clipboard]")
    assert share
    assert_includes share["data-clipboard-text-value"], "/#{post.user.username}"
    assert_equal 2, share.css("button[data-action='clipboard#copy']").size
  end

  test "renders form with action and method override" do
    post = build_persisted_post
    frag = render_fragment(post: post, submit_path: "/dashboard/posts/#{post.slug}", submit_method: :patch)
    form = frag.at_css("form")
    assert_equal "/dashboard/posts/#{post.slug}", form["action"]
    assert frag.at_css(%(input[name="_method"][value="patch"]))
  end

  test "renders borderless title and excerpt inputs" do
    frag = render_fragment(post: Post.new(status: :draft), submit_path: "/dashboard/posts", submit_method: :post)
    assert frag.at_css(%(input.ws-editor-title[name="post[title]"][placeholder="Untitled"]))
    assert frag.at_css(%(input.ws-editor-excerpt[name="post[excerpt]"]))
  end

  test "renders a Lexxy editor for the body, not Trix" do
    frag = render_fragment(post: Post.new(status: :draft), submit_path: "/dashboard/posts", submit_method: :post)
    editor = frag.at_css("lexxy-editor")
    assert editor, "lexxy editor should be present"
    assert_equal "post[body]", editor["name"]
    assert_nil frag.at_css("trix-editor")
    assert_nil frag.at_css("trix-toolbar")
  end

  test "published is a switch: checked value published, unchecked draft" do
    frag = render_fragment(post: Post.new(status: :draft), submit_path: "/dashboard/posts", submit_method: :post)
    box = frag.at_css(%(input[type="checkbox"][name="post[status]"]))
    assert box
    assert_equal "published", box["value"]
    assert_nil box["checked"]
    hidden = frag.at_css(%(input[type="hidden"][name="post[status]"]))
    assert_equal "draft", hidden["value"]
    assert_nil frag.at_css(%(select[name="post[status]"]))

    published = build_persisted_post
    published.update!(status: "published")
    frag = render_fragment(post: published, submit_path: "/dashboard/posts/#{published.slug}", submit_method: :patch)
    assert frag.at_css(%(input[type="checkbox"][name="post[status]"][checked]))
  end

  test "lists validation errors at the top" do
    post = Post.new(status: :draft)
    post.errors.add(:title, "can't be blank")
    frag = render_fragment(post: post, submit_path: "/dashboard/posts", submit_method: :post)
    assert_includes frag.at_css(".ws-editor-errors").text, "Title can't be blank"
  end
end
