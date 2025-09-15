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

  test "renders New Post title for new record and Edit Post for persisted" do
    new_post = Post.new(status: :draft)
    frag_new = render_fragment(post: new_post, submit_path: "/dashboard/posts", submit_method: :post)
    h1_new = frag_new.at_css("h1")
    assert_equal "New Post", h1_new.text.strip

    persisted = build_persisted_post
    frag_edit = render_fragment(post: persisted, submit_path: "/dashboard/posts/#{persisted.to_param}", submit_method: :patch)
    h1_edit = frag_edit.at_css("h1")
    assert_equal "Edit Post", h1_edit.text.strip
  end

  test "renders form with action and method override" do
    persisted = build_persisted_post
    frag = render_fragment(post: persisted, submit_path: "/dashboard/posts/#{persisted.to_param}", submit_method: :patch)

    form = frag.at_css(%(form[action="/dashboard/posts/#{persisted.to_param}"]))
    assert form, "should render form with given action"
    assert_equal "post", form["method"].to_s.downcase
    # PATCH should be via _method override
    assert form.at_css(%(input[name="_method"][value="patch"]))

    # New record uses POST, no _method override
    new_post = Post.new(status: :draft)
    frag2 = render_fragment(post: new_post, submit_path: "/dashboard/posts", submit_method: :post)
    form2 = frag2.at_css(%(form[action="/dashboard/posts"]))
    refute form2.at_css(%(input[name="_method"]))
  end

  test "renders title and excerpt inputs" do
    frag = render_fragment(post: Post.new(status: :draft), submit_path: "/dashboard/posts", submit_method: :post)
    title = frag.at_css(%(input[name="post[title]"]))
    excerpt = frag.at_css(%(input[name="post[excerpt]"]))
    assert title
    assert excerpt
  end

  test "renders ActionText body with custom toolbar bound" do
    frag = render_fragment(post: Post.new(status: :draft), submit_path: "/dashboard/posts", submit_method: :post)

    toolbar = frag.at_css("trix-toolbar")
    assert toolbar, "custom toolbar should be present"
    toolbar_id = toolbar["id"].to_s
    refute_empty toolbar_id

    editor = frag.at_css("trix-editor")
    assert editor, "trix editor should be present"
    assert_equal toolbar_id, editor["toolbar"]
  end

  test "renders status select with Post::STATUSES options titleized" do
    frag = render_fragment(post: Post.new(status: :draft), submit_path: "/dashboard/posts", submit_method: :post)
    select = frag.at_css(%(select[name="post[status]"]))
    assert select

    # Expect options for each status defined on the model
    expected = Post::STATUSES.map { |s| [ s.to_s.titleize, s.to_s ] }
    expected.each do |label, value|
      opt = select.css("option").find { |o| o["value"].to_s == value }
      assert opt, "missing option for #{value.inspect}"
      assert_equal label, opt.text
    end
  end

  test "shows validation error under body when present" do
    post = Post.new(status: :draft)
    post.errors.add(:body, "can't be blank")
    frag = render_fragment(post: post, submit_path: "/dashboard/posts", submit_method: :post)

    err = frag.css("p").find { |p| p["class"].to_s.include?("text-[var(--danger)]") }
    assert err, "expected a danger error paragraph"
    assert_match(/can't be blank/i, err.text)
  end

  test "renders Cancel link and Submit button with expected classes" do
    frag = render_fragment(post: Post.new(status: :draft), submit_path: "/dashboard/posts", submit_method: :post)

    cancel = frag.at_css(%(a[href="/dashboard"]))
    assert cancel
    assert_includes cancel["class"], "ring-[var(--border)]"

    submit = frag.at_css(%(button[type="submit"]))
    assert submit
    assert_includes submit["class"], "bg-[var(--btn-bg)]"
    assert_match(/Create|Save/, submit.text)
  end
end
