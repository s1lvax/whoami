require "test_helper"

class Dashboard::ExperienceItemComponentTest < ViewComponent::TestCase
  setup do
    @experience_data = {
      company: "ACME Inc.",
      role: "Senior Developer",
      location: "Luxembourg",
      start_date: Date.new(2020, 1, 1),
      end_date: Date.new(2021, 1, 1),
      highlights: [ "Built API integrations", "Led migration to Rails 7" ],
      tech: [ "Rails", "PostgreSQL" ]
    }
  end

  test "renders the role, company, location, and period" do
    render_inline(Dashboard::ExperienceItemComponent.new(**@experience_data))

    assert_text "Senior Developer"
    assert_text "ACME Inc."
    assert_text "Luxembourg"

    expected_period = "#{I18n.l(@experience_data[:start_date], format: :long)} — #{I18n.l(@experience_data[:end_date], format: :long)}"
    assert_text expected_period
  end

  test "renders highlights as list items when present" do
    render_inline(Dashboard::ExperienceItemComponent.new(**@experience_data))

    @experience_data[:highlights].each do |highlight|
      assert_text highlight
    end
  end

  test "renders tech tags when present" do
    render_inline(Dashboard::ExperienceItemComponent.new(**@experience_data))

    @experience_data[:tech].each do |tech|
      assert_text tech
    end
  end

  test "shows 'Present' for end date if nil" do
    @experience_data[:end_date] = nil
    render_inline(Dashboard::ExperienceItemComponent.new(**@experience_data))

    expected_period = "#{I18n.l(@experience_data[:start_date], format: :long)} — Present"
    assert_text expected_period
  end

  test "works with string date inputs" do
    data = @experience_data.merge(
      start_date: "2020-01-01",
      end_date: "2021-01-01"
    )
    render_inline(Dashboard::ExperienceItemComponent.new(**data))

    expected_period = "#{I18n.l(Date.parse(data[:start_date]), format: :long)} — #{I18n.l(Date.parse(data[:end_date]), format: :long)}"
    assert_text expected_period
  end

  test "renders correctly with empty highlights and tech" do
    data = @experience_data.merge(highlights: [], tech: [])
    render_inline(Dashboard::ExperienceItemComponent.new(**data))

    assert_no_text "Built API integrations"
    assert_no_text "Rails"
  end
end
