# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class PublicProfile::LinksSectionComponentTest < ViewComponent::TestCase
  module TestNormalizedUrlHelper
    def normalized_url(url) = url
  end

  setup do
    ApplicationController.helper(TestNormalizedUrlHelper)
  end

  UserStub = Struct.new(:username)
  LinkStub = Struct.new(:id, :label, :url)

  def render_fragment(user:, links:)
    Nokogiri::HTML.fragment(
      render_inline(PublicProfile::LinksSectionComponent.new(user: user, links: links)).to_html
    )
  end

  test "renders nothing when there are no links" do
    html = render_inline(PublicProfile::LinksSectionComponent.new(user: UserStub.new("tester"), links: [])).to_html
    assert_equal "", html.strip
  end

  test "renders each link label as a clickable item" do
    user  = UserStub.new("alice")
    links = [
      LinkStub.new(1, "My Site", "https://example.com/portfolio"),
      LinkStub.new(2, "GitHub", "http://github.com/alice")
    ]

    frag = render_fragment(user: user, links: links)
    labels = frag.css("a").map { |a| a.text.gsub(/\s+/, " ").strip }
    assert_includes labels.join(" "), "My Site"
    assert_includes labels.join(" "), "GitHub"
    assert_equal 2, frag.css("a").length
  end
end
