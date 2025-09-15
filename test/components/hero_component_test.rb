require "test_helper"

class HeroComponentTest < ViewComponent::TestCase
  test "renders the hero section with proper structure" do
    html = render_inline(HeroComponent.new).to_html

    # Check for main section wrapper
    assert_includes html, '<section class="py-24 text-center">'

    # Check for container div
    assert_includes html, 'class="mx-auto max-w-3xl px-6"'
  end

  test "renders the main headline with proper styling" do
    html = render_inline(HeroComponent.new).to_html

    # Check for h1 tag with styling
    assert_includes html, '<h1 class="text-3xl md:text-5xl font-extrabold mb-6">'

    # Check for headline text
    assert_includes html, "Build your"
    assert_includes html, "identity"
    assert_includes html, "online"

    # Check for highlighted word with proper styling
    assert_includes html, '<span class="text-[var(--btn-bg)]">identity</span>'
  end

  test "renders the description paragraph" do
    html = render_inline(HeroComponent.new).to_html

    # Check for paragraph with proper styling
    assert_includes html, 'class="max-w-xl mx-auto text-lg text-[var(--muted)] mb-8"'

    # Check for description content
    assert_includes html, "Whoami helps you showcase"
    assert_includes html, "personal brand"
    assert_includes html, "all in one place"
  end

  test "renders the call-to-action button" do
    html = render_inline(HeroComponent.new).to_html

    # Check for link with proper styling
    assert_includes html, 'class="inline-flex items-center px-6 py-3 rounded-lg bg-[var(--btn-bg)] text-[var(--btn-text)] font-semibold hover:bg-[var(--btn-hover-bg)] transition"'

    # Check for button text
    assert_includes html, "Create Your Profile"

    # Check that it links to the sign up path
    assert_includes html, 'href="/users/sign_up"'
  end

  test "renders the hero video with proper attributes" do
    html = render_inline(HeroComponent.new).to_html

    # Check for video tag
    assert_includes html, "<video"

    # Check for video attributes (Rails outputs them as full attributes)
    assert_includes html, 'autoplay="autoplay"'
    assert_includes html, 'muted="muted"'
    assert_includes html, 'loop="loop"'
    assert_includes html, 'playsinline="playsinline"'

    # Check that the video source includes the asset (Rails adds fingerprints)
    assert_match(/src="\/assets\/hero-[a-f0-9]+\.mp4"/, html)

    # Check for video styling
    assert_includes html, 'class="w-full max-w-5xl rounded-2xl ring-1 ring-[var(--border)]"'
  end

  test "renders video container with proper styling" do
    html = render_inline(HeroComponent.new).to_html

    # Check for video container
    assert_includes html, 'class="mt-12 flex justify-center"'
  end

  test "has proper responsive design classes" do
    html = render_inline(HeroComponent.new).to_html

    # Check for responsive text sizing
    assert_includes html, "text-3xl md:text-5xl"

    # Check for responsive max-width
    assert_includes html, "max-w-3xl"
    assert_includes html, "max-w-5xl"
  end

  test "uses CSS custom properties for theming" do
    html = render_inline(HeroComponent.new).to_html

    # Check that component uses CSS custom properties
    assert_includes html, "var(--btn-bg)"
    assert_includes html, "var(--btn-text)"
    assert_includes html, "var(--btn-hover-bg)"
    assert_includes html, "var(--muted)"
    assert_includes html, "var(--border)"
  end
end
