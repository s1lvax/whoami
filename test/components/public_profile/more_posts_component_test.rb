# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class PublicProfile::MorePostsComponentTest < ViewComponent::TestCase
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

  def render_fragment(posts:)
    html = render_inline(PublicProfile::MorePostsComponent.new(posts: posts)).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "renders empty state with header when there are no posts" do
    frag = render_fragment(posts: [])

    section = frag.at_css("section.rounded-2xl.bg-\\[var\\(--card\\)\\].ring-1.ring-\\[var\\(--border\\)\\].p-6")
    assert section

    h2 = section.at_css("h2.text-sm.uppercase.tracking-wide.text-\\[var\\(--muted\\)\\].mb-3")
    assert_equal "Read more from this user..", h2.text.strip

    empty = section.at_css("p.text-sm.text-\\[var\\(--muted\\)\\]")
    assert_equal "No posts yet.", empty.text.strip

    assert_nil section.at_css("ul.space-y-3")
  end

  test "renders list of posts with title, optional excerpt, date and pluralized views" do
    user = UserStub.new("tester")

    # deterministic dates
    published_on = Date.new(2025, 9, 1)
    updated_at   = Time.new(2025, 9, 10, 10, 0, 0)

    post1 = PostStub.new(
      title: "One",
      excerpt: "Short excerpt",
      views: 1,
      published_at: published_on,
      user: user
    )
    post2 = PostStub.new(
      title: "Two",
      excerpt: "", # no excerpt node
      views: 2,
      updated_at: updated_at,
      user: user
    )

    frag = render_fragment(posts: [ post1, post2 ])

    items = frag.css("ul.space-y-3 > li")
    assert_equal 2, items.length

    # Each item is fully wrapped in a link (we don't assert href to avoid route coupling)
    a1 = items[0].at_css("a.block.rounded-lg")
    a2 = items[1].at_css("a.block.rounded-lg")
    assert a1
    assert a2

    # Titles
    t1 = items[0].at_css("p.text-sm.font-medium").text.strip
    t2 = items[1].at_css("p.text-sm.font-medium").text.strip
    assert_equal "One", t1
    assert_equal "Two", t2

    # Excerpt presence/absence
    ex1 = items[0].at_css("p.text-xs.text-\\[var\\(--muted\\)\\].mt-1").text.strip
    assert_equal "Short excerpt", ex1
    assert_nil items[1].at_css("p.text-xs.text-\\[var\\(--muted\\)\\].mt-1")

    # Meta line: date + views (singular/plural)
    meta1 = items[0].at_css("p.text-\\[10px\\].text-\\[var\\(--muted\\)\\].mt-2").text
    meta2 = items[1].at_css("p.text-\\[10px\\].text-\\[var\\(--muted\\)\\].mt-2").text

    expected_date1 = published_on.to_fs(:long)
    expected_date2 = updated_at.to_date.to_fs(:long)

    assert_includes meta1, expected_date1
    assert_includes meta1, "1 view"

    assert_includes meta2, expected_date2
    assert_includes meta2, "2 views"
  end

  test "card styling classes are present on list items" do
    user = UserStub.new("u")
    post = PostStub.new(title: "Styled", excerpt: "x", views: 3, published_at: Date.today, user: user)

    frag = render_fragment(posts: [ post ])

    li = frag.at_css("ul.space-y-3 > li")
    link = li.at_css("a")
    assert link

    classes = link["class"]
    %w[block rounded-lg ring-1 bg-[var(--surface)] hover:bg-[var(--surface-2)] transition p-3 focus:outline-none focus:ring-2].each do |cls|
      assert_includes classes, cls
    end
    assert_includes classes, "ring-[var(--border)]"
    assert_includes classes, "focus:ring-[var(--btn-bg)]"
  end
end
