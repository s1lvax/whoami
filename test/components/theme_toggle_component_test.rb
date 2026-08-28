require "test_helper"

class ThemeToggleComponentTest < ViewComponent::TestCase
  test "renders a switchable theme control" do
    html = render_inline(ThemeToggleComponent.new).to_html

    assert_includes html, "data-controller=\"theme\""
    assert_includes html, "click->theme#toggle"
    assert_includes html, "Switch to light mode"
    assert_includes html, "theme-icon-sun"
    assert_includes html, "theme-icon-moon"
  end
end
