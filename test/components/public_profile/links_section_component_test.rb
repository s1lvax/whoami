# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class PublicProfile::LinksSectionComponentTest < ViewComponent::TestCase
  # Provide a minimal helper so the component's `helpers.normalized_url` call works in tests
  module TestNormalizedUrlHelper
    def normalized_url(url) = url # pass-through; template will strip the scheme itself
  end

  setup do
    ApplicationController.helper(TestNormalizedUrlHelper)
  end

  UserStub = Struct.new(:username)
  LinkStub = Struct.new(:id, :label, :url)

  def render_fragment(user:, links:)
    html = render_inline(
      PublicProfile::LinksSectionComponent.new(user: user, links: links)
    ).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "renders empty state with count 0" do
    user = UserStub.new("tester")
    frag = render_fragment(user: user, links: [])

    section = frag.at_css("section.rounded-2xl.bg-\\[var\\(--card\\)\\].ring-1.ring-\\[var\\(--border\\)\\].p-6.self-start")
    assert section

    h2 = section.at_css("h2.text-sm.uppercase.tracking-wide.text-\\[var\\(--muted\\)\\]")
    assert_equal "Links", h2.text.strip

    count = section.at_css("span.text-xs.text-\\[var\\(--muted\\)\\]").text.strip
    assert_equal "0", count

    empty = section.at_css("p.text-sm.text-\\[var\\(--muted\\)\\]")
    assert_equal "No links yet.", empty.text.strip

    assert_nil section.at_css("ul.space-y-2")
  end

  test "renders list items with label and normalized URL text (without scheme); updates count" do
    user  = UserStub.new("alice")
    links = [
      LinkStub.new(1, "My Site",       "https://example.com/portfolio"),
      LinkStub.new(2, "GitHub Profile", "http://github.com/alice")
    ]

    frag    = render_fragment(user: user, links: links)
    section = frag.at_css("section")

    count = section.at_css("span.text-xs.text-\\[var\\(--muted\\)\\]").text.strip
    assert_equal "2", count

    items = section.css("ul.space-y-2 > li")
    assert_equal 2, items.length

    # Labels
    label1 = items[0].at_css("p.text-sm.font-medium.truncate").text.strip
    label2 = items[1].at_css("p.text-sm.font-medium.truncate").text.strip
    assert_equal "My Site", label1
    assert_equal "GitHub Profile", label2

    # URL text should be shown without scheme (template strips it)
    url_text1 = items[0].at_css("p.text-xs.text-\\[var\\(--muted\\)\\].truncate").text.strip
    url_text2 = items[1].at_css("p.text-xs.text-\\[var\\(--muted\\)\\].truncate").text.strip
    assert_equal "example.com/portfolio", url_text1
    assert_equal "github.com/alice", url_text2

    # ↗ indicator
    arrow = items.first.at_css("span.text-\\[var\\(--muted\\)\\]")
    assert_equal "↗", arrow.text.strip
  end

  test "each list item wraps in a click link and has expected card classes" do
    user  = UserStub.new("bob")
    links = [ LinkStub.new(42, "Blog", "https://blog.example.org") ]

    frag = render_fragment(user: user, links: links)
    item = frag.at_css("ul.space-y-2 > li")

    # Card classes present
    classes = item["class"]
    %w[rounded-lg ring-1 bg-[var(--surface)] hover:bg-[var(--surface-2)] transition].each do |cls|
      assert_includes classes, cls
    end
    assert_includes classes, "ring-[var(--border)]"

    # Wrapper anchor exists (we don't assert href to avoid route coupling)
    link = item.at_css("a")
    assert link
  end
end
