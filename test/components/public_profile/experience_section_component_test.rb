# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class PublicProfile::ExperienceSectionComponentTest < ViewComponent::TestCase
  # Helpers -----------------------------------------------------------------
  #
  def squish(str)
    str.to_s.gsub(/\s+/, " ").strip
  end

  def render_html(experiences:)
    render_inline(PublicProfile::ExperienceSectionComponent.new(experiences: experiences)).to_html
  end

  def fragment_for(experiences:)
    Nokogiri::HTML.fragment(render_html(experiences: experiences))
  end

  def card_nodes(fragment)
    fragment.css("ul.space-y-3 > li")
  end

  # Tests -------------------------------------------------------------------

  test "renders empty state when there are no experiences" do
    frag = fragment_for(experiences: [])
    assert frag.at_css("section.rounded-2xl.bg-\\[var\\(--card\\)\\].ring-1.ring-\\[var\\(--border\\)\\].p-6")
    assert_equal "0", frag.at_css("span.text-xs.text-\\[var\\(--muted\\)\\]").text.strip
    assert_equal "No experience yet.", frag.at_css("p.text-sm.text-\\[var\\(--muted\\)\\]").text.strip
    assert_nil frag.at_css("ul.space-y-3")
  end

  test "renders count and a single experience card from hashes" do
    exps = [
      {
        role: "Senior Developer",
        company: "Acme Corp",
        location: "Berlin, DE",
        start_date: "Jan 2020",
        end_date: "Jun 2022",
        highlights: [ "Led payments migration", "Mentored 4 engineers" ],
        tech: [ "Rails", "Postgres", "Redis", "Stimulus", "Turbo" ]
      }
    ]

    frag = fragment_for(experiences: exps)

    # header and count
    assert_equal "Professional Experience", frag.at_css("h2").text.strip
    assert_equal "1", frag.at_css("span.text-xs.text-\\[var\\(--muted\\)\\]").text.strip

    # one card
    cards = card_nodes(frag)
    assert_equal 1, cards.count

    # role · company
    header_line = cards.first.at_css("p.text-base.font-medium").text
    assert_includes header_line, "Senior Developer"
    assert_includes header_line, "Acme Corp"
    assert_includes header_line, "·" # middle dot

    # dates
    dates = cards.first.at_css("span.text-xs.text-\\[var\\(--muted\\)\\]").text
    assert_includes dates, "Jan 2020"
    assert_includes dates, "Jun 2022"

    # location
    location = cards.first.at_css("p.mt-1.text-sm.text-\\[var\\(--muted\\)\\]").text
    assert_equal "Berlin, DE", location.strip

    # highlights
    hlis = cards.first.css("ul.list-disc li").map { |n| n.text.strip }
    assert_equal [ "Led payments migration", "Mentored 4 engineers" ], hlis

    # tech tags (first 4 only)
    tech_badges = cards.first.css("div.flex.flex-wrap span").map { |n| n.text.strip }
    assert_equal [ "Rails", "Postgres", "Redis", "Stimulus" ], tech_badges, "should cap to first 4 tech items"
  end

  test "shows 'Present' when end_date is blank" do
    exps = [
      { role: "Engineer", company: "Nowhere", start_date: "Mar 2023", end_date: nil }
    ]
    frag = fragment_for(experiences: exps)
    dates = frag.at_css("ul.space-y-3 li span.text-xs").text
    assert_includes dates, "Mar 2023"
    assert_includes dates, "Present"
  end

  test "accepts record-like objects responding to *_list helpers" do
    record = Struct.new(:role, :company, :location, :start_date, :end_date) do
      def highlights_list = [ "Scaled background jobs", "Cut p95 by 30%" ]
      def tech_list       = [ "Ruby", "Rails", "Sidekiq", "Postgres", "Grafana" ]
    end.new("Lead Engineer", "Widgets Inc.", "Remote", "2019", "2021")

    frag = fragment_for(experiences: [ record ])

    header_line = frag.at_css("ul.space-y-3 li p.text-base.font-medium").text
    assert_includes header_line, "Lead Engineer"
    assert_includes header_line, "Widgets Inc."

    # descriptions (highlights)
    hlis = frag.css("ul.space-y-3 li ul.list-disc li").map { |n| n.text.strip }
    assert_equal [ "Scaled background jobs", "Cut p95 by 30%" ], hlis

    # tech tags first 4
    tech_badges = frag.css("ul.space-y-3 li div.flex.flex-wrap span").map { |n| n.text.strip }
    assert_equal [ "Ruby", "Rails", "Sidekiq", "Postgres" ], tech_badges
  end

  test "omits location/highlights/tech sections when empty" do
    exps = [
      { role: "Engineer", company: "Barebones", start_date: "2020", end_date: "2021",
        location: "", highlights: [], tech: [] }
    ]
    frag = fragment_for(experiences: exps)
    card  = card_nodes(frag).first

    # no location paragraph
    assert_nil card.at_css("p.mt-1.text-sm.text-\\[var\\(--muted\\)\\]")

    # no highlights list
    assert_nil card.at_css("ul.list-disc")

    # no tech badges container
    assert_nil card.at_css("div.flex.flex-wrap")
  end

  test "renders multiple experiences in order given" do
    exps = [
      { role: "A", company: "One",  start_date: "2021", end_date: "2022" },
      { role: "B", company: "Two",  start_date: "2020", end_date: "2021" },
      { role: "C", company: "Three", start_date: "2019", end_date: "2020" }
    ]
    frag = fragment_for(experiences: exps)

    lines = card_nodes(frag).map { |li| squish(li.at_css("p.text-base.font-medium").text) }
    assert_equal [ "A · One", "B · Two", "C · Three" ], lines

    # count badge should match
    assert_equal "3", frag.at_css("span.text-xs.text-\\[var\\(--muted\\)\\]").text.strip
  end


  test "basic container and card classes are present" do
    frag = fragment_for(experiences: [ { role: "Dev", company: "X", start_date: "2020", end_date: "2021" } ])

    section = frag.at_css("section.rounded-2xl.bg-\\[var\\(--card\\)\\].ring-1.ring-\\[var\\(--border\\)\\].p-6")
    assert section

    card = frag.at_css("ul.space-y-3 > li")
    assert_includes card["class"], "rounded-lg"
    inner = card.at_css("div.px-4.py-3")
    assert inner
  end
end
