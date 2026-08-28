# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class Dashboard::NewExperienceCardComponentTest < ViewComponent::TestCase
  def render_fragment
    component = Dashboard::NewExperienceCardComponent.new
    component.define_singleton_method(:new_path) { "/dashboard/experience/new" }
    Nokogiri::HTML.fragment(render_inline(component).to_html)
  end

  test "renders an add tile inside the new_experience frame" do
    frag = render_fragment
    assert frag.at_css("turbo-frame#new_experience")

    link = frag.at_css('a.ws-add[href="/dashboard/experience/new"]')
    assert link
    assert_equal "new_experience", link["data-turbo-frame"]
    assert_equal "Add experience", link.text.squish
  end
end
