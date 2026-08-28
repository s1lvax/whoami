require "test_helper"

class Landing::FaqComponentTest < ViewComponent::TestCase
  test "answers real product questions" do
    html = render_inline(Landing::FaqComponent.new).to_html

    assert_includes html, "Is it free?"
    assert_includes html, "Is this Linktree?"
    assert_includes html, "open source"
    refute_includes html, "join creators"
    assert_equal 6, html.scan("<details>").size
  end
end
