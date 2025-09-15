# frozen_string_literal: true

require "test_helper"

class Dashboard::StatCardComponentTest < ViewComponent::TestCase
  test "renders label and value inside the card" do
    html = render_inline(
      Dashboard::StatCardComponent.new(label: "Profile Views", value: "1,234", delta: "+12%", up: true)
    ).to_html

    # outer card styling
    assert_includes html, 'class="rounded-xl bg-[var(--surface)] ring-1 ring-[var(--border)] p-4"'

    # label
    assert_includes html, '<p class="text-xs text-[var(--muted)]">Profile Views</p>'

    # value
    assert_includes html, '<p class="mt-2 text-2xl font-semibold">1,234</p>'
  end

  test "accepts numeric value and renders it as text" do
    html = render_inline(
      Dashboard::StatCardComponent.new(label: "Posts", value: 42, delta: -3, up: false)
    ).to_html

    assert_includes html, ">Posts<"
    assert_includes html, ">42<"
  end

  test "does not render delta or up (not used in template) and does not raise" do
    html = render_inline(
      Dashboard::StatCardComponent.new(label: "Clicks", value: "987", delta: "+5%", up: true)
    ).to_html

    # Just verify the expected bits are present and nothing crashes.
    assert_includes html, ">Clicks<"
    assert_includes html, ">987<"
    # Optional sanity: ensure delta text is not accidentally rendered
    refute_includes html, "+5%"
  end
end
