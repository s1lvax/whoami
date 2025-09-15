# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class ButtonComponentTest < ViewComponent::TestCase
  test "renders with default options" do
    html = render_inline(ButtonComponent.new) { "Submit" }.to_html
    fragment = Nokogiri::HTML.fragment(html)
    button = fragment.at_css("button")

    assert_equal "Submit", button.text.strip
    assert_equal "submit", button["type"]
    # When @name is nil, template renders name=""
    assert_equal "", button["name"]

    # Check default classes
    assert_includes button["class"], "w-full"                 # full width by default
    assert_includes button["class"], "bg-[var(--btn-bg)]"     # primary style default
  end

  test "renders secondary style button" do
    html = render_inline(ButtonComponent.new(style: :secondary)) { "Cancel" }.to_html
    button = Nokogiri::HTML.fragment(html).at_css("button")

    assert_equal "Cancel", button.text.strip
    assert_includes button["class"], "bg-[var(--muted-bg)]"
    refute_includes button["class"], "bg-[var(--btn-bg)]"
  end

  test "renders without full width" do
    html = render_inline(ButtonComponent.new(full_width: false)) { "Click me" }.to_html
    button = Nokogiri::HTML.fragment(html).at_css("button")

    assert_equal "Click me", button.text.strip
    refute_includes button["class"], "w-full"
  end

  test "renders with custom type" do
    html = render_inline(ButtonComponent.new(type: :button)) { "Press" }.to_html
    button = Nokogiri::HTML.fragment(html).at_css("button")

    assert_equal "Press", button.text.strip
    assert_equal "button", button["type"]
  end

  test "renders with name attribute" do
    html = render_inline(ButtonComponent.new(name: "confirm")) { "Confirm" }.to_html
    button = Nokogiri::HTML.fragment(html).at_css("button")

    assert_equal "Confirm", button.text.strip
    assert_equal "confirm", button["name"]
  end
end
