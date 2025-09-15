require "test_helper"

class Dashboard::ExperienceCardComponentTest < ViewComponent::TestCase
  def setup
    @experience = Experience.new(
      id: 42,
      company: "ACME Inc.",
      role: "Engineer",
      location: "Luxembourg",
      start_date: Date.new(2021, 1, 1),
      end_date: Date.new(2023, 1, 1),
      highlights: "Led team\nBuilt system",
      tech: "Ruby, PostgreSQL"
    )
  end

  test "renders role, company, location and date range" do
    render_inline(Dashboard::ExperienceCardComponent.new(experience: @experience))

    assert_text "Engineer"
    assert_text "ACME Inc. — Luxembourg"
    assert_text "Jan 2021 – Jan 2023"
  end

  test "wraps content in a turbo-frame with dom_id" do
    render_inline(Dashboard::ExperienceCardComponent.new(experience: @experience))

    assert_selector "turbo-frame##{dom_id(@experience)}"
  end

  test "renders highlights list as bullet points" do
    render_inline(Dashboard::ExperienceCardComponent.new(experience: @experience))

    assert_selector "ul li", text: "Led team"
    assert_selector "ul li", text: "Built system"
  end

  test "renders tech tags" do
    render_inline(Dashboard::ExperienceCardComponent.new(experience: @experience))

    assert_selector "span", text: "Ruby"
    assert_selector "span", text: "PostgreSQL"
  end

  test "renders delete link with turbo method and confirmation" do
    render_inline(Dashboard::ExperienceCardComponent.new(experience: @experience))

    assert_selector "a[data-turbo-method='delete'][data-turbo-confirm='Delete this experience?']"
  end
end
