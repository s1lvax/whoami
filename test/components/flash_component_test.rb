require "test_helper"

class FlashComponentTest < ViewComponent::TestCase
  test "renders notice message when notice is present" do
    html = render_inline(FlashComponent.new(notice: "Successfully saved!", alert: nil)).to_html

    # Check for notice container
    assert_includes html, 'class="w-full fixed top-0 left-0 z-50"'

    # Check for notice styling
    assert_includes html, 'class="mx-auto max-w-2xl bg-[color-mix(in_srgb,var(--success)_12%,transparent)] text-[var(--success)] border border-[var(--success)] rounded-b-lg shadow-md px-4 py-3 text-center"'

    # Check for notice content
    assert_includes html, "Successfully saved!"
  end

  test "renders alert message when alert is present" do
    html = render_inline(FlashComponent.new(notice: nil, alert: "Something went wrong!")).to_html

    # Check for alert container
    assert_includes html, 'class="w-full fixed top-0 left-0 z-50"'

    # Check for alert styling
    assert_includes html, 'class="mx-auto max-w-2xl bg-[color-mix(in_srgb,var(--danger)_12%,transparent)] text-[var(--danger)] border border-[var(--danger)] rounded-b-lg shadow-md px-4 py-3 text-center"'

    # Check for alert content
    assert_includes html, "Something went wrong!"
  end

  test "renders both notice and alert when both are present" do
    html = render_inline(FlashComponent.new(notice: "Success message", alert: "Error message")).to_html

    # Check that both messages are present
    assert_includes html, "Success message"
    assert_includes html, "Error message"

    # Check that both have their respective styling
    assert_includes html, "var(--success)"
    assert_includes html, "var(--danger)"
  end

  test "renders nothing when both notice and alert are nil" do
    html = render_inline(FlashComponent.new(notice: nil, alert: nil)).to_html

    # Should be empty or just whitespace
    assert html.strip.empty?, "Component should render nothing when both notice and alert are nil"
  end

  test "renders nothing when both notice and alert are blank strings" do
    html = render_inline(FlashComponent.new(notice: "", alert: "")).to_html

    # Should be empty or just whitespace
    assert html.strip.empty?, "Component should render nothing when both notice and alert are blank"
  end

  test "notice uses success color scheme" do
    html = render_inline(FlashComponent.new(notice: "Test notice", alert: nil)).to_html

    # Check for success color variables
    assert_includes html, "var(--success)"
    assert_includes html, "color-mix(in_srgb,var(--success)_12%,transparent)"
    assert_includes html, "border-[var(--success)]"
    assert_includes html, "text-[var(--success)]"
  end

  test "alert uses danger color scheme" do
    html = render_inline(FlashComponent.new(notice: nil, alert: "Test alert")).to_html

    # Check for danger color variables
    assert_includes html, "var(--danger)"
    assert_includes html, "color-mix(in_srgb,var(--danger)_12%,transparent)"
    assert_includes html, "border-[var(--danger)]"
    assert_includes html, "text-[var(--danger)]"
  end

  test "flash messages have proper positioning and layout" do
    html = render_inline(FlashComponent.new(notice: "Test", alert: nil)).to_html

    # Check for fixed positioning at top
    assert_includes html, "fixed top-0 left-0"

    # Check for high z-index
    assert_includes html, "z-50"

    # Check for full width
    assert_includes html, "w-full"

    # Check for centered content with max width
    assert_includes html, "mx-auto max-w-2xl"
  end

  test "flash messages have proper visual styling" do
    html = render_inline(FlashComponent.new(notice: "Test", alert: nil)).to_html

    # Check for rounded bottom corners
    assert_includes html, "rounded-b-lg"

    # Check for shadow
    assert_includes html, "shadow-md"

    # Check for padding
    assert_includes html, "px-4 py-3"

    # Check for centered text
    assert_includes html, "text-center"
  end

  test "handles HTML content safely" do
    html_content = "<script>alert('xss')</script>Safe content"
    html = render_inline(FlashComponent.new(notice: html_content, alert: nil)).to_html

    # Check that HTML is escaped (ViewComponent should handle this automatically)
    assert_includes html, "&lt;script&gt;"
    assert_includes html, "Safe content"
  end

  test "handles long messages" do
    long_message = "This is a very long message that should still be displayed properly within the flash component " * 3
    html = render_inline(FlashComponent.new(notice: long_message, alert: nil)).to_html

    # Check that the message is included
    assert_includes html, long_message

    # Check that styling is still applied
    assert_includes html, "max-w-2xl"
  end

  test "handles special characters in messages" do
    special_message = "Üser nämé wäs sävéd! 💾 Success! 🎉"
    html = render_inline(FlashComponent.new(notice: special_message, alert: nil)).to_html

    # Check that special characters are handled properly
    assert_includes html, special_message
  end

  test "uses modern CSS color-mix function for background" do
    html = render_inline(FlashComponent.new(notice: "Test", alert: nil)).to_html

    # Check for modern color-mix syntax
    assert_includes html, "color-mix(in_srgb,var(--success)_12%,transparent)"

    html = render_inline(FlashComponent.new(notice: nil, alert: "Test")).to_html
    assert_includes html, "color-mix(in_srgb,var(--danger)_12%,transparent)"
  end

  test "multiple flash messages render in separate containers" do
    html = render_inline(FlashComponent.new(notice: "Notice", alert: "Alert")).to_html

    # Count the number of fixed containers
    fixed_containers = html.scan(/class="w-full fixed top-0 left-0 z-50"/).length
    assert_equal 2, fixed_containers, "Should have two separate fixed containers for notice and alert"
  end
end
