require "test_helper"

class FooterComponentTest < ViewComponent::TestCase
  test "renders the footer with proper structure and styling" do
    html = render_inline(FooterComponent.new).to_html

    # Check for main footer wrapper
    assert_includes html, '<footer class="mt-24 border-t border-[var(--border)] bg-[var(--card)]">'

    # Check for container div
    assert_includes html, 'class="max-w-6xl mx-auto px-6 py-12 flex flex-col md:flex-row items-center justify-between gap-6"'
  end

  test "renders the left section with brand and copyright" do
    html = render_inline(FooterComponent.new).to_html

    # Check for left section wrapper
    assert_includes html, 'class="text-center md:text-left"'

    # Check for brand name
    assert_includes html, '<p class="text-lg font-semibold">whoami</p>'

    # Check for copyright with current year
    current_year = Time.current.year
    assert_includes html, "© #{current_year} Whoami. All rights reserved."
    assert_includes html, 'class="text-sm text-[var(--muted)] mt-1"'
  end

  test "renders navigation links in center section" do
    html = render_inline(FooterComponent.new).to_html

    # Check for nav wrapper
    assert_includes html, '<nav class="flex flex-wrap justify-center gap-6 text-sm text-[var(--text)]">'

    # Check for anchor links
    assert_includes html, 'href="#features"'
    assert_includes html, 'href="#blog"'
    assert_includes html, 'href="#about"'

    # Check for link text
    assert_includes html, ">Features<"
    assert_includes html, ">Blog<"
    assert_includes html, ">About<"
    assert_includes html, ">Privacy Policy<"
    assert_includes html, ">Terms of Service<"
  end

  test "renders route-based navigation links" do
    html = render_inline(FooterComponent.new).to_html

    # These will depend on your actual routes, adjust as needed
    # The test assumes privacy_path and terms_path helpers exist
    assert_match(/href=".*privacy.*"/, html)
    assert_match(/href=".*terms.*"/, html)
  end

  test "applies hover styles to navigation links" do
    html = render_inline(FooterComponent.new).to_html

    # Check that all nav links have hover styling
    nav_links = html.scan(/class="hover:text-red-500 transition"/)
    assert_equal 5, nav_links.length # Features, Blog, About, Privacy, Terms
  end

  test "renders GitHub social link in right section" do
    html = render_inline(FooterComponent.new).to_html

    # Check for right section wrapper
    assert_includes html, 'class="flex items-center gap-4"'

    # Check for GitHub link
    assert_includes html, 'href="https://github.com/s1lvax/whoami"'
    assert_includes html, 'class="text-[var(--muted)] hover:text-red-500 transition"'
  end

  test "renders GitHub SVG icon with proper attributes" do
    html = render_inline(FooterComponent.new).to_html

    # Check for SVG element
    assert_includes html, '<svg xmlns="http://www.w3.org/2000/svg"'
    assert_includes html, 'class="w-5 h-5"'
    assert_includes html, 'fill="currentColor"'
    assert_includes html, 'viewBox="0 0 24 24"'

    # Check that it contains path data (GitHub icon)
    assert_includes html, '<path fill-rule="evenodd"'
  end

  test "uses CSS custom properties for theming" do
    html = render_inline(FooterComponent.new).to_html

    # Check that component uses CSS custom properties
    assert_includes html, "var(--border)"
    assert_includes html, "var(--card)"
    assert_includes html, "var(--muted)"
    assert_includes html, "var(--text)"
  end

  test "has responsive design classes" do
    html = render_inline(FooterComponent.new).to_html

    # Check for responsive layout classes
    assert_includes html, "flex-col md:flex-row"
    assert_includes html, "text-center md:text-left"
    assert_includes html, "max-w-6xl"
  end

  test "renders current year dynamically" do
    # Test that the year updates dynamically
    travel_to Time.zone.local(2025, 6, 15) do
      html = render_inline(FooterComponent.new).to_html
      assert_includes html, "© 2025 Whoami"
    end

    travel_to Time.zone.local(2026, 3, 10) do
      html = render_inline(FooterComponent.new).to_html
      assert_includes html, "© 2026 Whoami"
    end
  end

  test "external GitHub link opens properly" do
    html = render_inline(FooterComponent.new).to_html

    # Verify the GitHub link is external and properly formatted
    github_link_match = html.match(/href="https:\/\/github\.com\/s1lvax\/whoami"/)
    assert_not_nil github_link_match, "GitHub link should be present and properly formatted"
  end
end
