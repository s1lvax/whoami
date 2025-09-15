# frozen_string_literal: true

require "test_helper"
require "nokogiri"
require "active_model"

class Dashboard::LinkFormCardComponentTest < ViewComponent::TestCase
  # Minimal model so form_with(model: ...) works
  class FakeLink
    include ActiveModel::Model
    include ActiveModel::Conversion
    extend  ActiveModel::Naming

    attr_accessor :label, :url
    def persisted? = false
  end

  # Render helper that does not depend on `controller`
  def render_fragment(link: FakeLink.new)
    component = Dashboard::LinkFormCardComponent.new(link: link)
    # Ensure form action is predictable regardless of routes
    component.define_singleton_method(:create_path) { "/dashboard/favorite_links" }

    html = render_inline(component).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "wraps content in turbo frame and <li> with expected classes" do
    frag = render_fragment

    frame = frag.at_css("turbo-frame#new_favorite_link")
    assert frame

    li = frame.at_css("li")
    assert li
    classes = li["class"].to_s
    %w[rounded-lg ring-1 ring-[var(--border)] bg-[var(--surface)] p-3].each do |c|
      assert_includes classes, c
    end
  end

   test "renders submit button and Cancel link with expected classes and turbo-frame" do
    frag = render_fragment

    submit = frag.at_css('input[type="submit"][value="Add"]')
    assert submit
    submit_classes = submit["class"].to_s
    %w[
      inline-flex items-center justify-center rounded-md px-3 py-2 text-sm font-medium
      bg-[var(--btn-bg)] text-[var(--btn-text)] hover:bg-[var(--btn-hover-bg)]
    ].each { |c| assert_includes submit_classes, c }

    # The cancel link points to the real route in your app. If that route
    # exists, assert with a loose selector (href ends with /new).
    cancel = frag.at_css('a[data-turbo-frame="new_favorite_link"]')
    assert cancel
    assert_equal "Cancel", cancel.text.strip
    assert_match(%r{/dashboard/.*/new\z}, cancel["href"].to_s)

    cancel_classes = cancel["class"].to_s
    %w[
      inline-flex items-center justify-center rounded-md px-3 py-2 text-sm
      ring-1 ring-[var(--border)] bg-[var(--surface)] hover:bg-[var(--surface-2)]
    ].each { |c| assert_includes cancel_classes, c }
  end

  test "shows field and base errors when present" do
    link = FakeLink.new
    link.errors.add(:label, "can't be blank")
    link.errors.add(:url, "is invalid")
    link.errors.add(:base, "Something went wrong")

    component = Dashboard::LinkFormCardComponent.new(link: link)
    component.define_singleton_method(:create_path) { "/dashboard/favorite_links" }
    frag = Nokogiri::HTML.fragment(render_inline(component).to_html)

    texts = frag.css("p").map(&:text)
    assert texts.any? { |t| t.include?("can't be blank") }
    assert texts.any? { |t| t.include?("is invalid") }
    assert texts.any? { |t| t.include?("Something went wrong") }
  end
end
