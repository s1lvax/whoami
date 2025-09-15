# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class Onboarding::StepUsernameComponentTest < ViewComponent::TestCase
  fixtures :users

  # Provide a minimal URL helper used by the template
  module TestOnboardingPathHelper
    def onboarding_path(step:)
      "/onboarding?step=#{step}"
    end
  end

  setup do
    ApplicationController.helper(TestOnboardingPathHelper)
  end

  def fragment_for(user:)
    html = render_inline(Onboarding::StepUsernameComponent.new(user: user)).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "renders the form pointing to onboarding?step=username with PATCH (via _method) and data-turbo=true" do
    user = users(:one)
    frag = fragment_for(user:)

    form = frag.at_css("form")
    assert form, "form should render"
    assert_equal "/onboarding?step=username", form["action"]
    # Rails uses POST with a hidden _method=patch
    assert_equal "post", form["method"]

    method_override = form.at_css('input[name="_method"]')
    assert method_override, "should include hidden _method"
    assert_equal "patch", method_override["value"]

    # data-turbo attribute present
    turbo = form["data-turbo"]
    # Rails may serialize boolean true as "true"
    assert_equal "true", turbo
  end

  test "shows username-check controller wrapper, label, turbo frame with default status" do
    user = users(:one)
    frag = fragment_for(user:)
    form = frag.at_css("form")

    wrapper = form.at_css('div[data-controller="username-check"]')
    assert wrapper, "wrapper should have data-controller=username-check"

    # Label text
    label = wrapper.at_css("label.text-sm.font-medium.text-\\[var\\(--muted-contrast\\)\\]")
    assert_equal "Username (letters & digits only)", label.text.strip

    # Turbo Frame default contents
    frame = wrapper.at_css("turbo-frame#username_status")
    assert frame
    span  = frame.at_css("span")
    assert_equal "Type a username…", span.text.strip
    assert_includes span["class"], "text-sm"
    assert_includes span["class"], "text-[var(--muted)]"
  end

  test "renders InputComponent wired for Stimulus and ButtonComponent with Continue text" do
    user = users(:one)
    frag = fragment_for(user:)
    form = frag.at_css("form")

    # Find the actual input produced by InputComponent
    input = form.at_css('input[name="user[username]"]')
    assert input, "username input should be present"

    # Input options / Stimulus wiring
    assert_equal "off", input["autocomplete"]
    assert_equal "latin", input["inputmode"]
    assert_equal "false", input["spellcheck"]

    # Stimulus data attributes
    assert_equal "input->username-check#changed", input["data-action"]
    # data-username-check-target="input" becomes data-username-check-target in HTML
    assert_equal "input", input["data-username-check-target"]

    # ButtonComponent renders a submit button with "Continue"
    button = form.at_css('button[type="submit"]')
    assert button, "submit button should be present"
    assert_equal "Continue", button.text.strip
  end
end
