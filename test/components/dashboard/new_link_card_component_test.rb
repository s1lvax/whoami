# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class Dashboard::NewLinkCardComponentTest < ViewComponent::TestCase
  def render_fragment
    component = Dashboard::NewLinkCardComponent.new

    # Stub the private path helper so we don't need real routes in test
    component.define_singleton_method(:new_path) do
      "/dashboard/favorite_links/new"
    end

    html = render_inline(component).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "wraps content in the expected turbo frame" do
    frag = render_fragment
    frame = frag.at_css("turbo-frame#new_favorite_link")
    assert frame, "expected turbo-frame with id=new_favorite_link"
  end

  test "renders link to new favorite link form with expected attributes and classes" do
    frag = render_fragment

    link = frag.at_css('a[href="/dashboard/favorite_links/new"]')
    assert link, "expected anchor with stubbed href"

    # data-turbo-frame attribute
    assert_equal "new_favorite_link", link["data-turbo-frame"]

    # Classes (assert a subset to avoid brittleness)
    cls = link["class"].to_s
    %w[
      rounded-lg ring-1 p-3 flex items-center justify-center
      bg-[var(--surface)] hover:bg-[var(--surface-2)]
      ring-[var(--border)] h-full min-h-[64px] text-sm
    ].each { |c| assert_includes cls, c }
  end

  test "shows + Add link label" do
    frag = render_fragment
    # Expect a plus sign followed by 'Add link'
    assert_includes frag.text.gsub(/\s+/, " ").strip, "+ Add link"
  end
end
