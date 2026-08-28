require "test_helper"

class Landing::WalkComponentTest < ViewComponent::TestCase
  test "walks the real product without fake claims" do
    html = render_inline(Landing::WalkComponent.new).to_html

    assert_includes html, "What you get"
    assert_includes html, "Import from GitHub"
    assert_includes html, "Your own hostname"
    assert_includes html, "landing-shot"
    assert_includes html, "Work, in order"
    refute_includes html, "A page that is you"
    refute_includes html, "identity-"
    refute_includes html, "join creators"
    refute_includes html, "Everything you need to shine"
  end
end
