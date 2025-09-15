require "test_helper"

class Dashboard::ActivityItemComponentTest < ViewComponent::TestCase
  test "renders title and detail text" do
    render_inline(Dashboard::ActivityItemComponent.new(
      title: "User signed in",
      detail: "2025-09-14 14:03"
    ))

    assert_text "User signed in"
    assert_text "2025-09-14 14:03"
  end

  test "renders outer structure with flex layout" do
    render_inline(Dashboard::ActivityItemComponent.new(
      title: "New client added",
      detail: "John Doe – 2025-09-15"
    ))

    assert_selector "li.flex.items-start.justify-between.py-2"
  end
end
