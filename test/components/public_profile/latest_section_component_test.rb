# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class PublicProfile::LatestPostsSectionComponentTest < ViewComponent::TestCase
  UserStub = Struct.new(:username)

  class PostStub
    attr_reader :title, :excerpt, :views, :published_at, :updated_at, :user
    def initialize(title:, excerpt:, views:, published_at: nil, updated_at: Time.current, user:)
      @title        = title
      @excerpt      = excerpt
      @views        = views
      @published_at = published_at
      @updated_at   = updated_at
      @user         = user
    end
  end

  def render_fragment(user:, posts:, pagy:)
    html = render_inline(
      PublicProfile::LatestPostsSectionComponent.new(user: user, posts: posts, pagy: pagy)
    ).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "renders empty state and RSS link text/attrs when there are no posts" do
    user = UserStub.new("tester")
    # Single page => PaginationComponent doesn't render or call url_for
    pagy = Pagy.new(count: 0, page: 1, items: 10)

    frag = render_fragment(user: user, posts: [], pagy: pagy)

    section = frag.at_css("section.rounded-2xl.bg-\\[var\\(--card\\)\\].ring-1.ring-\\[var\\(--border\\)\\].p-6")
    assert section

    h2 = section.at_css("h2.text-sm.uppercase.tracking-wide.text-\\[var\\(--muted\\)\\]")
    assert_equal "Latest Posts", h2.text.strip

    rss = section.at_css('a[rel="alternate"][type="application/rss+xml"]')
    assert rss, "RSS link should be present"
    assert_equal "Subscribe (RSS Feed)", rss.text.strip

    empty = section.at_css("p.text-sm.text-\\[var\\(--muted\\)\\]")
    assert_equal "No posts yet.", empty.text.strip
  end

  test "renders posts with title, optional excerpt, date (published/updated), and pluralized views" do
    user = UserStub.new("tester")

    t1 = Date.new(2025, 9, 1) # deterministic date
    post1 = PostStub.new(
      title: "First Post",
      excerpt: "Short excerpt here",
      views: 1,
      published_at: t1,
      user: user
    )
    post2 = PostStub.new(
      title: "Second Post",
      excerpt: "", # no excerpt shown
      views: 2,
      updated_at: Time.new(2025, 9, 10, 10, 0, 0),
      user: user
    )

    # Keep it single-page to avoid PaginationComponent url_for calls
    pagy = Pagy.new(count: 2, page: 1, items: 10)

    frag = render_fragment(user: user, posts: [ post1, post2 ], pagy: pagy)

    items = frag.css("ul.space-y-3 > li")
    assert_equal 2, items.length

    # Titles
    title1 = items[0].at_css("p.text-sm.font-medium").text.strip
    title2 = items[1].at_css("p.text-sm.font-medium").text.strip
    assert_equal "First Post", title1
    assert_equal "Second Post", title2

    # Excerpt present for post1
    excerpt1 = items[0].at_css("p.text-xs.text-\\[var\\(--muted\\)\\].mt-1").text.strip
    assert_equal "Short excerpt here", excerpt1
    # No excerpt node for post2
    assert_nil items[1].at_css("p.text-xs.text-\\[var\\(--muted\\)\\].mt-1")

    # Dates + views
    expected_date1 = post1.published_at.to_fs(:long)
    meta1 = items[0].at_css("p.text-\\[10px\\].text-\\[var\\(--muted\\)\\].mt-2").text
    assert_includes meta1, expected_date1
    assert_includes meta1, "1 view"

    expected_date2 = post2.updated_at.to_date.to_fs(:long)
    meta2 = items[1].at_css("p.text-\\[10px\\].text-\\[var\\(--muted\\)\\].mt-2").text
    assert_includes meta2, expected_date2
    assert_includes meta2, "2 views"
  end

  test "renders pagination container when posts exist (even if single page renders nothing inside)" do
    user = UserStub.new("tester")
    post = PostStub.new(title: "Only Post", excerpt: "x", views: 3, published_at: Date.today, user: user)
    pagy = Pagy.new(count: 1, page: 1, items: 10) # single page

    frag = render_fragment(user: user, posts: [ post ], pagy: pagy)

    container = frag.at_css("div.mt-4")
    assert container, "Pagination container should be present"
    # With single page, PaginationComponent renders nothing, so container may be empty — that's fine.
  end
end
