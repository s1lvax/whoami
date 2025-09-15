# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class Onboarding::StepLinksComponentTest < ViewComponent::TestCase
  fixtures :users

  # Minimal URL helper so the template's onboarding_path works without real routes
  module TestOnboardingPathHelper
    def onboarding_path(step:)
      "/onboarding?step=#{step}"
    end
  end

  setup do
    ApplicationController.helper(TestOnboardingPathHelper)
  end

  def fragment_for(user:)
    html = render_inline(Onboarding::StepLinksComponent.new(user: user)).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "renders form to onboarding?step=links with PATCH via _method and data-turbo=true; Stimulus wiring present" do
    user = users(:one)
    frag = fragment_for(user: user)

    outer = frag.at_css('div[data-controller="links"]')
    assert outer, "should have data-controller='links' on wrapper"

    form = outer.at_css("form")
    assert form, "form should render"
    assert_equal "/onboarding?step=links", form["action"]
    assert_equal "post", form["method"]

    method_override = form.at_css('input[name="_method"]')
    assert method_override, "hidden _method should be present"
    assert_equal "patch", method_override["value"]

    assert_equal "true", form["data-turbo"]

    # List target container present
    list = form.at_css('#links-list[data-links-target="list"]')
    assert list, "links list container should be present"

    # Template target present with __INDEX__ placeholders
    template = form.at_css('template[data-links-target="template"]')
    assert template, "template node should be present"
    tmpl_html = template.inner_html
    assert_includes tmpl_html, "__INDEX__", "template should contain __INDEX__ placeholders"

    # Add button / limit hint
    add_btn = form.at_css('button[type="button"][data-action="links#add"]')
    assert add_btn, "Add link button should be present"
    assert_includes add_btn.text, "+ Add link"

    hint = form.at_css('span.text-xs.text-\\[var\\(--muted\\)\\]')
    assert_equal "Up to 10 links", hint.text.strip

    # Two submit buttons: Continue and Skip for now
    btn_primary = form.at_css('button[type="submit"]')
    assert btn_primary
    assert_includes btn_primary.text, "Continue"

    btn_secondary = form.at_css('button[type="submit"][name="skip"]')
    assert btn_secondary
    assert_includes btn_secondary.text, "Skip for now"
  end

  test "when user has no favorite_links, list renders with zero items" do
    user = users(:one)
    user.favorite_links.destroy_all if user.respond_to?(:favorite_links)
    frag = fragment_for(user: user)

    list = frag.at_css('#links-list[data-links-target="list"]')
    assert list
    # No rendered items inside fields_for
    assert_nil list.at_css('[data-links-target="item"]')
  end

  test "renders existing favorite_links via fields_for with proper inputs, hidden fields, and remove button" do
    user = users(:one)
    user.favorite_links.destroy_all if user.respond_to?(:favorite_links)

    # Build (no need to save) two links so fields_for iterates
    user.favorite_links.build(position: 0, label: "GitHub", url: "https://github.com/me")
    user.favorite_links.build(position: 1, label: "Blog",   url: "https://example.com")

    frag = fragment_for(user: user)
    list = frag.at_css('#links-list[data-links-target="list"]')
    items = list.css('[data-links-target="item"]')
    assert_equal 2, items.length, "should render one block per existing favorite_link"

    # First item assertions
    first = items.first

    # Hidden position field present
    pos = first.at_css('input[type="hidden"][name^="user[favorite_links_attributes]"][name$="[position]"]')
    assert pos, "position hidden input should be present"

    # Hidden _destroy field with target attribute
    destroy = first.at_css('input[type="hidden"][name$="[_destroy]"][data-links-target="destroy"]')
    assert destroy
    assert_equal "false", destroy["value"]

    # Remove button (Stimulus action)
    remove_btn = first.at_css('button[type="button"][data-action="links#remove"]')
    assert remove_btn
    assert_includes remove_btn.text, "Remove"

    # Labels rendered by InputComponent
    # (We don't depend on exact InputComponent markup beyond label texts and presence of inputs)
    label_lab = first.at_css('label:contains("Label (e.g., GitHub, Blog)")')
    url_lab   = first.at_css('label:contains("URL (https://...)")')
    assert label_lab, "Label field label should be present"
    assert url_lab,   "URL field label should be present"

    # Inputs for label and url should be nested-attribute names with index 0/1
    # We check they end with [label] / [url] and include the nested prefix
    text_inputs = first.css('input[type="text"]')
    assert text_inputs.any? { |i| i["name"]&.match?(/\Auser\[favorite_links_attributes\]\[\d+\]\[label\]\z/) }
    assert text_inputs.any? { |i| i["name"]&.match?(/\Auser\[favorite_links_attributes\]\[\d+\]\[url\]\z/) }
  end
end
