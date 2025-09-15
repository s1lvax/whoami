require "test_helper"

class ExperienceTest < ActiveSupport::TestCase
  fixtures :users

  def setup
    @user = users(:one)
  end

  def build_experience(attrs = {})
    Experience.new({
      user: @user,
      company: "Acme Corp",
      role: "Developer",
      start_date: Date.new(2020, 1, 1),
      end_date: Date.new(2021, 1, 1),
      highlights: "Did stuff\nAchieved results",
      tech: "Ruby, Rails, PostgreSQL"
    }.merge(attrs))
  end

  # --- validations -----------------------------------------------------------

  test "valid experience saves" do
    exp = build_experience
    assert exp.valid?, -> { exp.errors.full_messages.inspect }
  end

  test "requires company, role, and start_date" do
    [ :company, :role, :start_date ].each do |field|
      exp = build_experience(field => nil)
      assert_not exp.valid?, "expected #{field} to be required"
      assert_includes exp.errors[field], "can't be blank"
    end
  end

  test "end_date cannot be before start_date" do
    exp = build_experience(start_date: Date.today, end_date: Date.yesterday)
    assert_not exp.valid?
    assert_includes exp.errors[:end_date], "can't be before start date"
  end

  test "end_date can be equal to or after start_date" do
    today = Date.today
    exp1 = build_experience(start_date: today, end_date: today)
    exp2 = build_experience(start_date: today, end_date: today + 1.day)
    assert exp1.valid?, -> { exp1.errors.full_messages.inspect }
    assert exp2.valid?, -> { exp2.errors.full_messages.inspect }
  end

  test "end_date can be blank" do
    exp = build_experience(end_date: nil)
    assert exp.valid?, -> { exp.errors.full_messages.inspect }
  end

  # --- helpers ---------------------------------------------------------------

  test "highlights_list splits lines and strips blanks" do
    exp = build_experience(highlights: "First line\nSecond line\n\n  Third  ")
    assert_equal [ "First line", "Second line", "Third" ], exp.highlights_list
  end

  test "highlights_list limits to 10 items" do
    lines = (1..20).map { |i| "Item #{i}" }.join("\n")
    exp = build_experience(highlights: lines)
    assert_equal 10, exp.highlights_list.size
  end

  test "tech_list splits by comma and strips blanks" do
    exp = build_experience(tech: "Ruby, Rails ,  PostgreSQL ,,")
    assert_equal [ "Ruby", "Rails", "PostgreSQL" ], exp.tech_list
  end

  test "tech_list limits to 15 items" do
    techs = (1..30).map { |i| "Tech#{i}" }.join(",")
    exp = build_experience(tech: techs)
    assert_equal 15, exp.tech_list.size
  end
end
