# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class PublicProfile::ExperienceSectionComponentTest < ViewComponent::TestCase
  def fragment_for(experiences:)
    Nokogiri::HTML.fragment(
      render_inline(PublicProfile::ExperienceSectionComponent.new(experiences: experiences)).to_html
    )
  end

  test "renders nothing when there are no experiences" do
    html = render_inline(PublicProfile::ExperienceSectionComponent.new(experiences: [])).to_html
    assert_equal "", html.strip
  end

  test "renders role, company, dates, location, highlights, and tech" do
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
    text = frag.text.gsub(/\s+/, " ")

    assert_includes text, "Senior Developer · Acme Corp"
    assert_includes text, "Jan 2020"
    assert_includes text, "Jun 2022"
    assert_includes text, "Berlin, DE"
    assert_includes text, "Led payments migration"
    assert_includes text, "Mentored 4 engineers"
    assert_includes text, "Rails"
    assert_equal 5, frag.css("[data-tech]").length
  end

  test "shows an open range when end_date is blank" do
    frag = fragment_for(experiences: [ { role: "Engineer", company: "Nowhere", start_date: "Mar 2023", end_date: nil } ])
    assert_includes frag.text, "Mar 2023 – present"
  end

  test "accepts record-like objects with *_list helpers" do
    record = Struct.new(:role, :company, :location, :start_date, :end_date) do
      def highlights_list = [ "Scaled background jobs" ]
      def tech_list       = [ "Ruby", "Rails" ]
    end.new("Lead Engineer", "Widgets Inc.", "Remote", "2019", "2021")

    text = fragment_for(experiences: [ record ]).text
    assert_includes text, "Lead Engineer"
    assert_includes text, "Widgets Inc."
    assert_includes text, "Scaled background jobs"
    assert_includes text, "Ruby"
  end

  test "renders multiple experiences in the given order" do
    exps = [
      { role: "A", company: "One", start_date: "2021", end_date: "2022" },
      { role: "B", company: "Two", start_date: "2020", end_date: "2021" }
    ]
    items = fragment_for(experiences: exps).css("[data-experience]")
    assert_equal 2, items.length
    assert_includes items[0].text, "A"
    assert_includes items[1].text, "B"
  end
end
