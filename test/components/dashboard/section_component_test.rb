# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class Dashboard::SectionComponentTest < ViewComponent::TestCase
  def fragment_for(**args, &blk)
    html = render_inline(Dashboard::SectionComponent.new(**args), &blk).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "renders section with title and wrapper classes" do
    frag = fragment_for(title: "Analytics")

    section = frag.at_css("section")
    assert section
    # outer classes
    outer_classes = section["class"].to_s.split
    %w[rounded-xl bg-[var(--surface)] ring-1 ring-[var(--border)]].each do |cls|
      assert_includes outer_classes, cls
    end

    header = frag.at_css("header")
    assert header
    header_classes = header["class"].to_s.split
    %w[flex items-center justify-between px-4 py-3 border-b border-[var(--border)]].each do |cls|
      assert_includes header_classes, cls
    end

    # title
    assert_equal "Analytics", frag.at_css("h3.text-sm.font-medium")&.text
  end

  test "renders slot content inside body padding wrapper" do
    frag = fragment_for(title: "Recent Activity") { "<p>hello content</p>".html_safe }
    body = frag.at_css("div.p-4")
    assert body
    assert_includes body.inner_html, "<p>hello content</p>"
  end

  test "renders action link when action_label and action_href are provided" do
    frag = fragment_for(title: "Posts", action_label: "View all", action_href: "/dashboard/posts")

    link = frag.at_css('header a[href="/dashboard/posts"]')
    assert link
    assert_equal "View all", link.text.strip
    link_classes = link["class"].to_s.split
    %w[text-xs underline underline-offset-2 text-[var(--link)] hover:text-[var(--link-hover)]].each do |cls|
      assert_includes link_classes, cls
    end
  end

  test "does not render action link if action_label is missing" do
    frag = fragment_for(title: "Posts", action_label: nil, action_href: "/dashboard/posts")
    refute frag.at_css('header a[href="/dashboard/posts"]')
  end

  test "does not render action link if action_href is missing" do
    frag = fragment_for(title: "Posts", action_label: "View all", action_href: nil)
    refute frag.at_css("header a")
  end
end
