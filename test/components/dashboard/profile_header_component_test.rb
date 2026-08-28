# frozen_string_literal: true

require "test_helper"
require "nokogiri"
require "base64"

class Dashboard::ProfileHeaderComponentTest < ViewComponent::TestCase
  fixtures :users

  def fragment_for(user:, edit_href: "/settings/profile")
    html = render_inline(Dashboard::ProfileHeaderComponent.new(user: user, edit_href: edit_href)).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "renders display name, handle, bio, and edit link" do
    user = users(:one)
    user.bio = "A short bio about me."

    frag = fragment_for(user:)
    assert_equal user.full_name, frag.at_css(".ws-profile-name").text.strip
    assert_equal "@#{user.handle}", frag.at_css(".ws-profile-handle").text.strip
    assert_equal "A short bio about me.", frag.at_css(".ws-profile-bio").text.strip

    edit_link = frag.at_css('a[data-turbo-frame="profile_header"]')
    assert edit_link
    assert_equal "/settings/profile", edit_link["href"]
    assert_equal "Edit profile", edit_link.text.strip

    refute frag.at_css("form"), "no logout form in the profile card anymore"
  end

  test "hides edit link when edit_href is blank" do
    frag = fragment_for(user: users(:one), edit_href: nil)
    refute frag.at_css('a[data-turbo-frame="profile_header"]')
  end

  test "renders initials fallback avatar as a data URI tile" do
    user = users(:one)
    user.avatar.detach if user.avatar&.attached?

    img = fragment_for(user:).at_css("img.avatar.avatar-tile")
    assert img
    assert img["src"].start_with?("data:image/svg+xml;utf8,")
    assert_equal user.full_name, img["alt"]
  end

  test "renders ActiveStorage variant URL when avatar is attached" do
    user = users(:one)
    png = Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO3bA2QAAAAASUVORK5CYII=")
    user.avatar.attach(io: StringIO.new(png), filename: "avatar.png", content_type: "image/png")

    img = fragment_for(user:).at_css("img.avatar")
    assert_match(%r{\A/rails/active_storage/representations/}, img["src"])
  end

  test "falls back to email for display name when full_name is blank" do
    user = users(:one).dup
    user.name = nil
    user.family_name = nil
    user.email = "no-name@example.com"

    assert_equal "no-name@example.com", fragment_for(user:).at_css(".ws-profile-name").text.strip
  end
end
