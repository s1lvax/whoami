# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class Dashboard::NewLinkCardComponentTest < ViewComponent::TestCase
  def render_fragment
    component = Dashboard::NewLinkCardComponent.new
    component.define_singleton_method(:new_path) { "/dashboard/favorite_links/new" }
    Nokogiri::HTML.fragment(render_inline(component).to_html)
  end

  test "renders an add tile inside the new_favorite_link frame" do
    frag = render_fragment
    assert frag.at_css("turbo-frame#new_favorite_link")

    link = frag.at_css('a.ws-add[href="/dashboard/favorite_links/new"]')
    assert link
    assert_equal "new_favorite_link", link["data-turbo-frame"]
    assert_equal "Add link", link.text.squish
    assert link.at_css("svg")
  end
end
