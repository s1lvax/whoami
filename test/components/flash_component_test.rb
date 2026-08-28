require "test_helper"

class FlashComponentTest < ViewComponent::TestCase
  test "renders a notice as a status toast" do
    render_inline(FlashComponent.new(notice: "Successfully saved!", alert: nil))

    assert_selector ".flash[role='status']", text: "Successfully saved!"
    assert_no_selector ".flash-alert"
  end

  test "renders an alert as an alert toast" do
    render_inline(FlashComponent.new(notice: nil, alert: "Something went wrong!"))

    assert_selector ".flash.flash-alert[role='alert']", text: "Something went wrong!"
  end

  test "renders both when both are present" do
    render_inline(FlashComponent.new(notice: "Saved", alert: "Careful"))

    assert_selector ".flash", count: 2
    assert_selector ".flash[role='status']", text: "Saved"
    assert_selector ".flash-alert[role='alert']", text: "Careful"
  end

  test "renders nothing when both are blank" do
    render_inline(FlashComponent.new(notice: nil, alert: ""))

    assert_no_selector ".flash"
  end

  test "escapes html in messages" do
    render_inline(FlashComponent.new(notice: "<b>bold</b>", alert: nil))

    assert_includes rendered_content, "&lt;b&gt;bold&lt;/b&gt;"
  end
end
