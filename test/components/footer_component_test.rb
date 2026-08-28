require "test_helper"

class FooterComponentTest < ViewComponent::TestCase
  test "renders brand, legal links, and the source repo" do
    html = render_inline(FooterComponent.new).to_html

    assert_includes html, "whoami"
    assert_includes html, "© #{Time.current.year}"
    assert_match(/privacy/, html)
    assert_match(/terms/, html)
    assert_includes html, "https://github.com/s1lvax/whoami"
    refute_includes html, "#blog"
    assert_includes html, "wordmark"
  end
end
