
require "test_helper"
require "nokogiri"
require "cgi"

class FeaturesComponentTest < ViewComponent::TestCase
  # --- helpers --------------------------------------------------------------

  def render_html
    render_inline(FeaturesComponent.new).to_html
  end

  def doc(html)
    Nokogiri::HTML.fragment(html)
  end

  # normalize curly quotes and HTML entities so we can compare text sanely
  def normalize_text(str)
    CGI.unescapeHTML(str.to_s).gsub("’", "'")
  end

  # returns array of the six <h3> title texts (decoded, normalized)
  def feature_titles(html)
    doc(html).css("h3.text-xl.font-semibold.mb-2").map { |n| normalize_text(n.text) }
  end

  # returns all feature description paragraph texts (decoded, normalized)
  def feature_descriptions(html)
    # skip the main subtitle by scoping to feature cards
    cards = doc(html).css("div.rounded-xl.bg-\\[var\\(--card\\)\\].ring-1.ring-\\[var\\(--border\\)\\].p-6.text-left")
    cards.map { |card| normalize_text(card.at_css("p.text-\\[var\\(--muted\\)\\]").text) }
  end

  # --- structure & styling checks (unchanged) -------------------------------

  test "renders the features section with proper structure" do
    html = render_html
    assert_includes html, '<section id="features" class="py-24">'
    assert_includes html, 'class="max-w-6xl mx-auto px-6 text-center mb-16"'
    assert_includes html, 'class="max-w-6xl mx-auto grid md:grid-cols-3 gap-8 px-6"'
  end

  test "renders the section header with proper styling" do
    html = render_html
    assert_includes html, '<h2 class="text-3xl md:text-4xl font-bold mb-4">Everything you need to shine</h2>'
    assert_includes html, '<p class="text-lg text-[var(--muted)]">Whoami gives you the tools to present yourself authentically online.</p>'
  end

  test "renders all six feature cards" do
    html = render_html
    feature_cards = html.scan(/class="rounded-xl bg-\[var\(--card\)\] ring-1 ring-\[var\(--border\)\] p-6 text-left"/).length
    assert_equal 6, feature_cards, "Should render exactly 6 feature cards"
  end

  # --- content checks (now decode & normalize) ------------------------------

  test "renders Profile & Bio feature" do
    titles = feature_titles(render_html)
    assert_includes titles, "Profile & Bio"
    # also ensure description exists for that card
    descs = feature_descriptions(render_html)
    assert_includes descs, "Create a beautiful profile with your name, bio, and avatar. Think of it as your digital business card."
  end

  test "renders Links feature" do
    titles = feature_titles(render_html)
    assert_includes titles, "Links"
    descs = feature_descriptions(render_html)
    assert_includes descs, "Share your portfolio, social media, or favorite resources. Track clicks and see what resonates."
  end

  test "renders Blog feature" do
    titles = feature_titles(render_html)
    assert_includes titles, "Blog"
    descs = feature_descriptions(render_html)
    assert_includes descs, "Publish posts with a clean editor and rich text. Grow your voice, your way."
  end

  test "renders CV & Experience feature" do
    titles = feature_titles(render_html)
    assert_includes titles, "CV & Experience"
    descs = feature_descriptions(render_html)
    assert_includes descs, "Add your professional journey and let visitors download your CV instantly."
  end

  test "renders Analytics feature" do
    titles = feature_titles(render_html)
    assert_includes titles, "Analytics"
    # curly vs straight apostrophe tolerant
    descs = feature_descriptions(render_html)
    expected = "Track profile views, link clicks, and post reads—see what's working."
    assert_includes descs.map { |d| normalize_text(d) }, expected
  end

  test "renders Simple & Secure feature" do
    titles = feature_titles(render_html)
    assert_includes titles, "Simple & Secure"
    descs = feature_descriptions(render_html)
    expected = "Backed by Rails 8, Turbo, and secure authentication. You're in safe hands."
    assert_includes descs.map { |d| normalize_text(d) }, expected
  end

  # --- consistency & theming (unchanged) ------------------------------------

  test "all feature cards have consistent styling" do
    html = render_html
    expected_card_class = 'class="rounded-xl bg-[var(--card)] ring-1 ring-[var(--border)] p-6 text-left"'
    card_count = html.scan(/#{Regexp.escape(expected_card_class)}/).length
    assert_equal 6, card_count, "All 6 feature cards should have consistent styling"
  end

  test "all feature titles have consistent styling" do
    html = render_html
    h3_count = html.scan(/class="text-xl font-semibold mb-2"/).length
    assert_equal 6, h3_count, "All 6 feature titles should have consistent styling"
  end

  test "all feature descriptions have consistent styling" do
    html = render_html
    muted_paragraphs = html.scan(/<p class="text-\[var\(--muted\)\]">(?!Whoami gives you)/).length
    assert_equal 6, muted_paragraphs, "All 6 feature descriptions should have muted text styling"
  end

  test "has proper responsive design classes" do
    html = render_html
    assert_includes html, "grid md:grid-cols-3"
    assert_includes html, "text-3xl md:text-4xl"
    max_width_containers = html.scan(/max-w-6xl/).length
    assert_equal 2, max_width_containers, "Should have two max-w-6xl containers"
  end

  test "uses CSS custom properties for theming" do
    html = render_html
    assert_includes html, "var(--muted)"
    assert_includes html, "var(--card)"
    assert_includes html, "var(--border)"
  end

  test "has proper semantic structure" do
    html = render_html
    assert_includes html, "<section"
    assert_includes html, "<h2"
    assert_includes html, "<h3"
    h2_count = html.scan(/<h2/).length
    h3_count = html.scan(/<h3/).length
    assert_equal 1, h2_count, "Should have exactly one h2 for the section title"
    assert_equal 6, h3_count, "Should have exactly six h3 elements for feature titles"
  end

  test "section has proper anchor for navigation" do
    html = render_html
    assert_includes html, 'id="features"'
  end

  test "features are presented in expected order" do
    html = render_html
    titles = feature_titles(html)
    expected_titles = [
      "Profile & Bio",
      "Links",
      "Blog",
      "CV & Experience",
      "Analytics",
      "Simple & Secure"
    ]
    assert_equal expected_titles, titles, "Features should be in the expected order"
  end

  test "maintains proper spacing and layout structure" do
    html = render_html
    assert_includes html, "py-24"
    assert_includes html, "mb-16"
    assert_includes html, "gap-8"
    card_padding_count = html.scan(/p-6/).length
    assert_equal 6, card_padding_count, "All feature cards should have consistent padding"
  end
end
