# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class Dashboard::NewExperienceCardComponentTest < ViewComponent::TestCase
  def render_fragment
    component = Dashboard::NewExperienceCardComponent.new

    # Stub the private path so we don't need actual routes in test
    component.define_singleton_method(:new_path) { "/dashboard/experience/new" }

    html = render_inline(component).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "wraps content in the expected turbo frame" do
    frag = render_fragment
    frame = frag.at_css("turbo-frame#new_experience")
    assert frame, "expected turbo-frame with id=new_experience"
  end

  test "renders link with expected attributes and classes" do
    frag = render_fragment
    link = frag.at_css('a[href="/dashboard/experience/new"]')
    assert link, "expected anchor with stubbed href"

    assert_equal "new_experience", link["data-turbo-frame"]

    cls = link["class"].to_s
    %w[
      rounded-lg ring-1 p-3 flex items-center justify-center
      bg-[var(--surface)] hover:bg-[var(--surface-2)]
      ring-[var(--border)] h-full min-h-[64px] text-sm
    ].each { |c| assert_includes cls, c }
  end

  test "shows + Add experience label" do
    frag = render_fragment
    assert_includes frag.text.gsub(/\s+/, " ").strip, "+ Add experience"
  end
end
