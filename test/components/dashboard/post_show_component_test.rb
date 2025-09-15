# frozen_string_literal: true

require "test_helper"

class Dashboard::PostShowComponentTest < ViewComponent::TestCase
  fixtures :users

  def build_post(attrs = {})
    user = users(:one)
    defaults = {
      user: user,
      title: "Test Post",
      status: "published",
      excerpt: "Excerpt here",
      body: "<div>Body <strong>HTML</strong></div>",
      views: 2,
      published_at: Time.zone.parse("2024-06-01 10:00")
    }
    Post.create!(defaults.merge(attrs))
  end

  def render_for(post)
    component = Dashboard::PostShowComponent.new(post: post)

    # Provide deterministic URLs without relying on Rails routes/helpers
    edit_url = "/dashboard/posts/#{post.to_param}/edit"
    show_url = "/dashboard/posts/#{post.to_param}"

    # Define singleton methods instead of stubbing
    component.singleton_class.class_eval do
      define_method(:edit_path)  { edit_url }
      define_method(:delete_path) { show_url }
    end

    render_inline(component).to_html
  end

  test "renders title, meta (Published), views pluralization, and body HTML" do
    post = build_post(views: 2)
    html = render_for(post)

    # Title
    assert_includes html, '<h1 class="text-xl md:text-2xl font-semibold">Test Post</h1>'

    # Meta line
    expected_date = post.published_at.to_date.to_fs(:long)
    assert_includes html, "Published · #{expected_date} · 2 views"

    # Body
    assert_includes html, '<div class="trix-content max-w-none">'
    assert_includes html, "Body <strong>HTML</strong>"
  end

  test "renders Draft and falls back to updated_at for date" do
    post = build_post(status: "draft", published_at: nil, views: 3)
    post.update!(updated_at: Time.zone.parse("2025-02-15 12:00"))
    html = render_for(post)

    expected_date = post.updated_at.to_date.to_fs(:long)
    assert_includes html, "Draft · #{expected_date} · 3 views"
  end

  test "views pluralization handles singular correctly (1 view)" do
    post = build_post(views: 1)
    html = render_for(post)
    assert_includes html, "1 view"
    refute_includes html, "1 views"
  end

  test "renders Edit and Delete links with expected classes and data attributes" do
    post = build_post
    html = render_for(post)
    doc  = Nokogiri::HTML.fragment(html)

    edit  = doc.at_css(%Q(a[href="/dashboard/posts/#{post.to_param}/edit"]))
    del   = doc.at_css(%Q(a[href="/dashboard/posts/#{post.to_param}"]))

    assert edit, "Edit link not found"
    assert del,  "Delete link not found"

    # Tokenize class attributes so line-breaks/spacing don't matter
    edit_classes = edit["class"].to_s.split
    del_classes  = del["class"].to_s.split

    expected_tokens = %w[
      inline-flex items-center rounded-md px-4 py-2 text-sm ring-1 ring-[var(--border)]
      bg-[var(--surface)] hover:bg-[var(--surface-2)]
    ]

    expected_tokens.each { |tok| assert_includes edit_classes, tok }
    expected_tokens.each { |tok| assert_includes del_classes, tok }
    assert_includes del_classes, "text-[var(--danger)]"

    # Data attributes on Delete
    assert_equal "delete", del["data-turbo-method"]
    assert_equal "Delete this post?", del["data-turbo-confirm"]

    # Link texts
    assert_equal "Edit",   edit.text.strip
    assert_equal "Delete", del.text.strip
  end


  test "outer structure and classes render correctly" do
    post = build_post
    html = render_for(post)

    assert_includes html, '<section class="p-12">'
    assert_includes html, '<div class="mx-auto max-w-3xl">'
    assert_includes html, '<p class="text-xs text-[var(--muted)] text-center mb-4">'
  end
end
