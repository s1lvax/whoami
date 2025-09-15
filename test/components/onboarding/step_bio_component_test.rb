# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class Onboarding::StepBioComponentTest < ViewComponent::TestCase
  fixtures :users

  # Minimal helper so the template's onboarding_path works without real routes
  module TestOnboardingPathHelper
    def onboarding_path(step:)
      "/onboarding?step=#{step}"
    end
  end

  setup do
    ApplicationController.helper(TestOnboardingPathHelper)
  end

  def fragment_for(user:)
    html = render_inline(Onboarding::StepBioComponent.new(user: user)).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "renders form to onboarding?step=bio with PATCH via _method and data-turbo=true" do
    user = users(:one)
    frag = fragment_for(user:)

    form = frag.at_css("form")
    assert form, "form should render"
    assert_equal "/onboarding?step=bio", form["action"]
    assert_equal "post", form["method"] # Rails uses hidden _method for PATCH

    method_override = form.at_css('input[name="_method"]')
    assert method_override, "should include hidden _method"
    assert_equal "patch", method_override["value"]

    assert_equal "true", form["data-turbo"]
  end

  test "renders bio textarea via InputComponent with correct label and attributes" do
    user = users(:one)
    frag = fragment_for(user:)
    form = frag.at_css("form")

    # Label (from InputComponent)
    label = form.at_css('label:contains("Short bio")')
    assert label, "Short bio label should be present"

    # Textarea rendered by InputComponent
    textarea = form.at_css('textarea[name="user[bio]"]')
    assert textarea, "user[bio] textarea should be present"

    # Attributes passed through input_options
    assert_equal "4", textarea["rows"]
    assert_equal "What do you do? What are you into?", textarea["placeholder"]
    # Extra class merged
    assert_includes textarea["class"], "min-h-[6rem]"
  end

  test "renders error message for bio when present" do
    user = users(:one)
    user.errors.add(:bio, "is too long (maximum is 280 characters)")

    frag = fragment_for(user:)
    form = frag.at_css("form")

    error_p = form.at_css('p.text-xs.text-\\[var\\(--danger\\)\\]')
    assert error_p, "error paragraph should render when user has bio errors"
    assert_includes error_p.text, "is too long (maximum is 280 characters)"
  end

  test "renders both submit buttons: Continue and Skip for now" do
    user = users(:one)
    frag = fragment_for(user:)
    form = frag.at_css("form")

    continue_btn = form.at_css('button[type="submit"]')
    assert continue_btn
    assert_equal "Continue", continue_btn.text.strip

    skip_btn = form.at_css('button[type="submit"][name="skip"]')
    assert skip_btn
    assert_equal "Skip for now", skip_btn.text.strip
  end
end
