require "test_helper"

class Dashboard::ExperienceSectionComponentTest < ViewComponent::TestCase
  def build_experience(attrs = {})
    Experience.new({
      company: "TechCorp",
      role: "Engineer",
      location: "Luxembourg",
      start_date: Date.new(2020, 1, 1),
      end_date: Date.new(2021, 1, 1),
      tech: "Rails, PostgreSQL",
      highlights: "Built cool stuff\nLed a team"
    }.merge(attrs))
  end

  def experience_as_keywords(exp)
    {
      company:    exp.company,
      role:       exp.role,
      location:   exp.location,
      start_date: exp.start_date,
      end_date:   exp.end_date,
      highlights: exp.highlights_list,
      tech:       exp.tech_list
    }
  end

  test "renders 'no experience yet' message when experiences are blank" do
    render_inline(Dashboard::ExperienceSectionComponent.new(experiences: []))

    assert_text "No experience yet. Start by adding your first role."
    refute_text "Software Engineer"
  end

  test "renders the title and company of each experience when provided" do
    exp = build_experience(role: "Senior Dev", company: "ACME Inc.")
    render_inline(Dashboard::ExperienceSectionComponent.new(experiences: [ experience_as_keywords(exp) ]))

    assert_text "Senior Dev"
    assert_text "ACME Inc."
  end

  test "renders the custom Manage CV link if action_href is provided" do
    render_inline(Dashboard::ExperienceSectionComponent.new(
      experiences: [],
      action_href: "/dashboard/experiences"
    ))

    assert_selector "a[href='/dashboard/experiences']", text: "Manage CV"
  end

  test "renders default Manage CV link when action_href is not provided" do
    render_inline(Dashboard::ExperienceSectionComponent.new(experiences: []))

    assert_selector "a[href='/experience/new']", text: "Manage CV"
  end
end
