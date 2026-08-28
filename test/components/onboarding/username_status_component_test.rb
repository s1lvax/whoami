# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class Onboarding::UsernameStatusComponentTest < ViewComponent::TestCase
  def frag_for(status:)
    html = render_inline(Onboarding::UsernameStatusComponent.new(status: status)).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "renders default message and muted style when status is nil" do
    frag = frag_for(status: nil)

    frame = frag.at_css("turbo-frame#username_status")
    assert frame, "should be wrapped in turbo_frame_tag 'username_status'"

    span = frame.at_css("span")
    assert_equal "Type a username…", span.text.strip
    assert_equal "false", span["data-available"]
    assert_includes span["class"], "status"
  end

  test "renders :ok tone with emerald class and data-available=true" do
    status = { text: "Looks good!", tone: :ok }
    span   = frag_for(status:).at_css("span")

    assert_equal "Looks good!", span.text.strip
    assert_equal "true", span["data-available"]
    assert_includes span["class"], "is-ok"
  end

  test "renders :error tone with danger class and data-available=false" do
    status = { text: "Already taken", tone: :error }
    span   = frag_for(status:).at_css("span")

    assert_equal "Already taken", span.text.strip
    assert_equal "false", span["data-available"]
    assert_includes span["class"], "is-error"
  end

  test "renders other/unknown tone as muted (fallback branch)" do
    status = { text: "Checking…", tone: :checking }
    span   = frag_for(status:).at_css("span")

    assert_equal "Checking…", span.text.strip
    assert_equal "false", span["data-available"]
    assert_includes span["class"], "status"
    refute_includes span["class"], "is-ok"
    refute_includes span["class"], "is-error"
  end
end
