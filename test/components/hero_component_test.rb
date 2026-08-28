require "test_helper"

class HeroComponentTest < ViewComponent::TestCase
  test "states the product and links to sign up" do
    html = render_inline(HeroComponent.new(page_href: "/cfds")).to_html

    assert_includes html, "One link."
    assert_includes html, "whoami.tech/"
    assert_includes html, "Create yours"
    assert_includes html, 'href="/users/sign_up"'
    assert_includes html, "See a live page"
    assert_includes html, 'href="/cfds"'
    assert_includes html, "sample-frame"
    assert_includes html, 'class="landing-claim"'
    assert_includes html, 'name="username"'
    assert_includes html, 'data-controller="username-check"'
    assert_includes html, "Claim yours"
    refute_includes html, "<video"
    refute_includes html, "already using"
  end

  test "signed-in visitors get the page, not sign up" do
    html = render_inline(HeroComponent.new(signed_in: true, page_href: "/cfds")).to_html

    assert_includes html, "Open your page"
    refute_includes html, "Create yours"
    refute_includes html, "landing-claim"
  end
end
