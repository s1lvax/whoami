require "test_helper"

class ButtonComponentTest < ViewComponent::TestCase
  def button_for(**opts, &block)
    render_inline(ButtonComponent.new(**opts), &block)
    page.find("button")
  end

  test "renders a full-width primary submit by default" do
    button = button_for { "Submit" }
    assert_equal "Submit", button.text.strip
    assert_equal "submit", button["type"]
    assert_includes button["class"], "btn"
    assert_includes button["class"], "btn-primary"
    assert_includes button["class"], "btn-block"
  end

  test "renders secondary style" do
    button = button_for(style: :secondary) { "Cancel" }
    assert_includes button["class"], "btn-secondary"
  end

  test "renders without full width" do
    button = button_for(full_width: false) { "Click me" }
    refute_includes button["class"], "btn-block"
  end

  test "renders with custom type and name" do
    button = button_for(type: :button, name: "confirm") { "Press" }
    assert_equal "button", button["type"]
    assert_equal "confirm", button["name"]
  end
end
