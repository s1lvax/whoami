require "test_helper"

class Landing::SampleComponentTest < ViewComponent::TestCase
  include Rails.application.routes.url_helpers
  fixtures :users

  test "renders a fallback example when no live user is passed" do
    html = render_inline(Landing::SampleComponent.new).to_html

    assert_includes html, "Cesário Silva"
    assert_includes html, "@cfds"
    assert_includes html, "What a page looks like"
    assert_includes html, "sample-frame"
    assert_includes html, "link-glyph"
  end

  test "renders a live onboarded user when passed" do
    user = users(:one)
    html = render_inline(Landing::SampleComponent.new(user: user)).to_html

    assert_includes html, user.display_name
    assert_includes html, "A real page"
    assert_includes html, public_profile_path(user.username)
  end
end
