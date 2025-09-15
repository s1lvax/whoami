# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class CtaComponentTest < ViewComponent::TestCase
  # Make sure path helpers (Devise) are available
  include Rails.application.routes.url_helpers

  test "renders headline, copy, and CTA link" do
    html = render_inline(CtaComponent.new).to_html
    fragment = Nokogiri::HTML.fragment(html)

    # Section wrapper
    section = fragment.at_css("section.py-24.text-center")
    assert section, "Section with .py-24.text-center should be present"

    # Headline
    h2 = section.at_css("h2.text-3xl.md\\:text-4xl.font-bold.mb-4")
    assert h2, "Headline h2 should be present"
    assert_equal "Ready to build your identity?", h2.text.strip

    # Sub copy
    p = section.at_css("p.text-lg.text-\\[var\\(--muted\\)\\].mb-8")
    assert p, "Sub copy paragraph should be present"
    assert_equal "Join creators, professionals, and makers already using Whoami.", p.text.strip

    # CTA link
    link = section.at_css("a")
    assert link, "CTA link should be present"
    assert_equal "Create Your Profile Now", link.text.strip
    assert_equal new_user_registration_path, link["href"]

    # Classes on the link (sanity check)
    expected_classes = %w[
      inline-flex items-center px-6 py-3 rounded-lg
      bg-red-500 text-white font-semibold hover:bg-red-600 transition
    ]
    expected_classes.each do |cls|
      assert_includes link["class"], cls
    end
  end
end
