require "test_helper"

class Landing::PitchComponentTest < ViewComponent::TestCase
  test "contrasts real alternatives without fake claims" do
    html = render_inline(Landing::PitchComponent.new).to_html

    assert_includes html, "LinkedIn"
    assert_includes html, "Linktree"
    assert_includes html, "GitHub"
    assert_includes html, "whoami"
    assert_includes html, "Put it everywhere"
    assert_includes html, "is-us"
    refute_includes html, "download your CV"
    refute_includes html, "join creators"
  end
end
