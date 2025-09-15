# frozen_string_literal: true

require "test_helper"
require "nokogiri"
require "base64"

class Dashboard::ProfileHeaderComponentTest < ViewComponent::TestCase
  fixtures :users

  # Minimal routes/helpers used by the component
  module TestRoutesHelper
    def destroy_user_session_path
      "/users/sign_out"
    end
  end

  setup do
    ApplicationController.helper(TestRoutesHelper)
  end

  def fragment_for(user:, edit_href: "/settings/profile")
    html = render_inline(
      Dashboard::ProfileHeaderComponent.new(user: user, edit_href: edit_href)
    ).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "renders wrapper, display name, handle, optional bio, edit link and logout button" do
    user = users(:one) # has name + family_name -> full_name, username, etc.
    user.bio = "A short bio about me."

    frag = fragment_for(user:)
    section = frag.at_css("section")
    assert section
    section_classes = section["class"].to_s.split
    %w[rounded-xl bg-[var(--surface)] ring-1 ring-[var(--border)] p-6].each { |c| assert_includes section_classes, c }

    # display name prefers full_name
    h2 = frag.at_css("h2.text-lg.sm\\:text-xl.font-semibold")
    assert h2
    assert_equal user.full_name, h2.text.strip

    # handle is prefixed with '@'
    handle_p = frag.at_css("p.text-sm.text-\\[var\\(--muted\\)\\]")
    assert handle_p
    assert_equal "@#{user.handle}", handle_p.text.strip

    # bio shown when present
    bio_p = frag.at_css("p.mt-3.text-sm.leading-relaxed")
    assert bio_p
    assert_equal "A short bio about me.", bio_p.text.strip

    # edit link present when edit_href provided
    edit_link = frag.at_css('a[data-turbo-frame="profile_header"]')
    assert edit_link
    assert_equal "/settings/profile", edit_link["href"]
    assert_equal "Edit profile", edit_link.text.strip

    # logout button_to rendered as <form><button …>
    logout_form = frag.at_css('form[action="/users/sign_out"][method="post"]')
    assert logout_form
    method_input = logout_form.at_css('input[name="_method"][value="delete"]')
    assert method_input
    logout_button = logout_form.at_css('button[type="submit"]')
    assert logout_button
    assert_equal "Logout", logout_button.text.strip
  end

  test "hides edit link when edit_href is blank" do
    user = users(:one)
    frag = fragment_for(user:, edit_href: nil)
    refute frag.at_css('a[data-turbo-frame="profile_header"]'), "edit link should not render without edit_href"
  end

  test "renders fallback avatar <img> with data: URI when user has no avatar" do
    user = users(:one)
    user.avatar.detach if user.avatar&.attached?

    frag = fragment_for(user:)
    img = frag.at_css("img")
    assert img, "avatar <img> should render"

    # Should use data URI (fallback SVG)
    assert img["src"].start_with?("data:image/svg+xml;utf8,"), "fallback avatar should be a data: URI"
    assert_equal user.full_name, img["alt"]

    classes = img["class"].to_s.split
    %w[w-16 h-16 sm:w-20 sm:h-20 rounded-full ring-2 ring-[var(--border)] object-cover].each { |c| assert_includes classes, c }
  end

  test "renders ActiveStorage variant URL when avatar is attached" do
    user = users(:one)

    # 1x1 transparent PNG
    tiny_png_base64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO3bA2QAAAAASUVORK5CYII="
    png_bytes = Base64.decode64(tiny_png_base64)

    user.avatar.attach(
      io: StringIO.new(png_bytes),
      filename: "avatar.png",
      content_type: "image/png"
    )

    frag = fragment_for(user:)
    img  = frag.at_css("img")
    assert img, "avatar <img> should render"

    src = img["src"].to_s
    refute src.start_with?("data:"), "attached avatar should not be a data: URI"

    # We don't need to compute the full expected URL; it's enough to ensure it's an ActiveStorage representation
    assert_match(%r{\A/rails/active_storage/representations/}, src, "should look like an ActiveStorage representations URL")
  end

  test "falls back to email for display name when full_name is blank" do
    # Build a lightweight user without name/family_name
    user = User.new(email: "no-name@example.com", username: "noname")
    frag  = fragment_for(user:)
    h2    = frag.at_css("h2")
    assert_equal "no-name@example.com", h2.text.strip
  end

  test "handle falls back to username, then email local-part when user has no #handle method" do
    user = User.new(email: "xuser@example.com", username: "xuser")
    frag  = fragment_for(user:)
    handle_p = frag.at_css("p.text-sm.text-\\[var\\(--muted\\)\\]")
    assert_equal "@xuser", handle_p.text.strip

    user2 = User.new(email: "local@example.com", username: nil)
    frag2 = fragment_for(user: user2)
    handle_p2 = frag2.at_css("p.text-sm.text-\\[var\\(--muted\\)\\]")
    assert_equal "@local", handle_p2.text.strip
  end
end
