# frozen_string_literal: true

require "test_helper"

class Dashboard::SectionComponentTest < ViewComponent::TestCase
  def render_section(**opts, &block)
    render_inline(Dashboard::SectionComponent.new(**opts), &block)
    Nokogiri::HTML.fragment(rendered_content)
  end

  test "renders a card with title, id, and count" do
    frag = render_section(title: "Links", id: "links", count: "3 of 6") { "<p>hello</p>".html_safe }

    section = frag.at_css("section#links.card.card-pad")
    assert section
    assert_equal "Links 3 of 6", section.at_css("h2").text.squish
    assert_includes section.inner_html, "<p>hello</p>"
  end

  test "renders action button only when label and href are given" do
    frag = render_section(title: "Writing", action_label: "Write", action_href: "/posts/new") { "" }
    link = frag.at_css("a.btn[href='/posts/new']")
    assert link
    assert_equal "Write", link.text.strip

    refute render_section(title: "Writing", action_label: "Write") { "" }.at_css("a.btn")
    refute render_section(title: "Writing", action_href: "/x") { "" }.at_css("a.btn")
  end
end
