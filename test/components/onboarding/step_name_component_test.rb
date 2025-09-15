# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class Onboarding::StepNameComponentTest < ViewComponent::TestCase
  fixtures :users

  # Minimal helper so the template's onboarding_path works without routes
  module TestOnboardingPathHelper
    def onboarding_path(step:)
      "/onboarding?step=#{step}"
    end
  end

  setup do
    ApplicationController.helper(TestOnboardingPathHelper)
  end

  def fragment_for(user:)
    html = render_inline(Onboarding::StepNameComponent.new(user: user)).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "renders form to onboarding?step=name with PATCH via _method and data-turbo=true" do
    user = users(:one)
    frag = fragment_for(user:)

    form = frag.at_css("form")
    assert form, "form should render"
    assert_equal "/onboarding?step=name", form["action"]
    assert_equal "post", form["method"] # Rails uses hidden _method for PATCH

    method_override = form.at_css('input[name="_method"]')
    assert method_override, "hidden _method should be present"
    assert_equal "patch", method_override["value"]

    assert_equal "true", form["data-turbo"]
  end

  test "renders first and family name inputs with correct labels and attributes" do
    user = users(:one)
    frag = fragment_for(user:)
    form = frag.at_css("form")

    # Labels (from InputComponent)
    first_label  = form.at_css('label:contains("First name")')
    family_label = form.at_css('label:contains("Family name")')
    assert first_label,  "First name label should be present"
    assert family_label, "Family name label should be present"

    # Inputs rendered by InputComponent
    first_input  = form.at_css('input[name="user[name]"]')
    family_input = form.at_css('input[name="user[family_name]"]')
    assert first_input,  "user[name] input should be present"
    assert family_input, "user[family_name] input should be present"

    # Attributes
    assert_equal "given-name", first_input["autocomplete"]
    # autofocus is a boolean attribute; presence is enough
    assert first_input.attribute("autofocus"), "first name input should have autofocus"

    assert_equal "family-name", family_input["autocomplete"]
    refute family_input.attribute("autofocus"), "family name input should not have autofocus"
  end

  test "renders error messages for name and family_name when present on user" do
    # Add errors to a user instance (no save required)
    user = users(:one)
    user.errors.add(:name, "can't be blank")
    user.errors.add(:family_name, "is too long (maximum is 80 characters)")

    frag = fragment_for(user:)
    form = frag.at_css("form")

    name_error = form.at_css('p.text-xs.text-\\[var\\(--danger\\)\\]')
    assert name_error
    assert_includes name_error.text, "can't be blank"

    # There are two error <p> elements; grab all and check one includes family message
    errors = form.css('p.text-xs.text-\\[var\\(--danger\\)\\]')
    assert errors.length >= 2, "should render an error for each field with errors"
    assert errors.any? { |p| p.text.include?("is too long (maximum is 80 characters)") }
  end
end
