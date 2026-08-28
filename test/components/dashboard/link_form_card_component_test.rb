# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class Dashboard::LinkFormCardComponentTest < ViewComponent::TestCase
  class FakeLink
    include ActiveModel::Model
    include ActiveModel::Conversion
    extend  ActiveModel::Naming

    attr_accessor :label, :url
    def persisted? = false
  end

  def render_fragment(link: FakeLink.new)
    render_inline(Dashboard::LinkFormCardComponent.new(link: link))
    Nokogiri::HTML.fragment(rendered_content)
  end

  test "wraps the inline form in the new_favorite_link turbo frame" do
    frag = render_fragment
    assert frag.at_css("turbo-frame#new_favorite_link li.ws-inline-form form")
    assert frag.at_css('input[name$="[label]"]')
    assert frag.at_css('input[name$="[url]"]')
  end

  test "renders Add submit and a Cancel link targeting the frame" do
    frag = render_fragment

    assert frag.at_css('input[type="submit"][value="Add"].btn')

    cancel = frag.at_css('a[data-turbo-frame="new_favorite_link"]')
    assert cancel
    assert_equal "Cancel", cancel.text.strip
    assert_match(%r{/dashboard/.*/new\z}, cancel["href"].to_s)
  end

  test "shows field and base errors when present" do
    link = FakeLink.new
    link.errors.add(:label, "can't be blank")
    link.errors.add(:url, "is invalid")
    link.errors.add(:base, "Something went wrong")

    texts = render_fragment(link:).css("p.error").map(&:text)
    assert texts.any? { |t| t.include?("can't be blank") }
    assert texts.any? { |t| t.include?("is invalid") }
    assert texts.any? { |t| t.include?("Something went wrong") }
  end
end
