# frozen_string_literal: true

require "test_helper"

class Dashboard::PostShowComponentTest < ViewComponent::TestCase
  fixtures :users

  def build_post(attrs = {})
    Post.create!({
      user: users(:one),
      title: "Test Post",
      status: "published",
      excerpt: "Excerpt here",
      body: "<div>Body <strong>HTML</strong></div>",
      views: 2,
      published_at: Time.zone.parse("2024-06-01 10:00")
    }.merge(attrs))
  end

  def render_for(post)
    component = Dashboard::PostShowComponent.new(post: post)
    edit_url = "/dashboard/posts/#{post.to_param}/edit"
    show_url = "/dashboard/posts/#{post.to_param}"
    component.singleton_class.class_eval do
      define_method(:edit_path)  { edit_url }
      define_method(:delete_path) { show_url }
    end
    render_inline(component)
    Nokogiri::HTML.fragment(rendered_content)
  end

  test "renders title, published chip, date, views and body" do
    post = build_post(views: 2)
    frag = render_for(post)

    assert_equal "Test Post", frag.at_css("h1.ws-post-title").text.strip
    assert_equal "Published", frag.at_css(".chip.chip-ok").text.strip
    assert_includes frag.at_css(".ws-post-meta-row").text, post.published_at.to_date.to_fs(:long)
    assert_includes frag.at_css(".ws-post-meta-row").text, "2 reads"
    assert_includes frag.at_css(".post-body .prose").inner_html, "Body <strong>HTML</strong>"
  end

  test "renders Draft without the ok chip and falls back to updated_at" do
    post = build_post(status: "draft", published_at: nil, views: 1)
    post.update!(updated_at: Time.zone.parse("2025-02-15 12:00"))
    frag = render_for(post)

    chip = frag.at_css(".chip")
    assert_equal "Draft", chip.text.strip
    refute_includes chip["class"], "chip-ok"
    assert_includes frag.at_css(".ws-post-meta-row").text, post.updated_at.to_date.to_fs(:long)
    assert_includes frag.at_css(".ws-post-meta-row").text, "1 read"
    refute_includes frag.at_css(".ws-post-meta-row").text, "1 reads"
  end

  test "renders Edit and Delete actions" do
    post = build_post
    frag = render_for(post)

    edit = frag.at_css(%Q(a[href="/dashboard/posts/#{post.to_param}/edit"]))
    del  = frag.at_css(%Q(a[href="/dashboard/posts/#{post.to_param}"]))

    assert_includes edit["class"], "btn-primary"
    assert_includes del["class"], "btn-danger"
    assert_equal "delete", del["data-turbo-method"]
    assert_equal "Delete this post?", del["data-turbo-confirm"]
  end
end
