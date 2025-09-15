require "test_helper"

class Dashboard::ExperienceFormCardComponentTest < ViewComponent::TestCase
  def setup
    @experience = Experience.new(
      company: "ACME Inc.",
      role: "Engineer",
      location: "Luxembourg",
      start_date: Date.new(2021, 1, 1),
      end_date: Date.new(2022, 1, 1),
      highlights: "Built a team\nScaled the product",
      tech: "Ruby, Rails"
    )
  end

  test "renders all form fields and buttons inside turbo frame" do
    render_inline(Dashboard::ExperienceFormCardComponent.new(experience: @experience))

    assert_selector "turbo-frame[id=new_experience]"
    assert_selector "form[action='#{Rails.application.routes.url_helpers.dashboard_experiences_path}']"
    assert_selector "input[name='experience[company]'][value='ACME Inc.']"
    assert_selector "input[name='experience[role]'][value='Engineer']"
    assert_selector "input[name='experience[location]'][value='Luxembourg']"
    assert_selector "input[name='experience[start_date]']"
    assert_selector "input[name='experience[end_date]']"
    assert_selector "textarea[name='experience[highlights]']", text: "Built a team\nScaled the product"
    assert_selector "input[name='experience[tech]'][value='Ruby, Rails']"
    assert_selector "input[type=submit][value='Add']"
    assert_selector "a[href='#{Rails.application.routes.url_helpers.new_dashboard_experience_path}']", text: "Cancel"
  end

  test "shows field-level validation errors when present" do
    @experience.errors.add(:company, "can't be blank")
    @experience.errors.add(:start_date, "must be valid")
    render_inline(Dashboard::ExperienceFormCardComponent.new(experience: @experience))

    assert_text "can't be blank"
    assert_text "must be valid"
  end

  test "shows base error when present" do
    @experience.errors.add(:base, "Something went wrong")
    render_inline(Dashboard::ExperienceFormCardComponent.new(experience: @experience))

    assert_text "Something went wrong"
  end
end
