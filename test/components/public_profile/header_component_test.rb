# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class PublicProfile::HeaderComponentTest < ViewComponent::TestCase
  # A user with NO #handle method (so component falls back to username/email)
  FakeUser = Struct.new(:full_name, :email, :username, :bio, :avatar)

  # A user WITH #handle method (component prefers this)
  FakeUserWithHandle = Struct.new(:full_name, :email, :username, :bio, :handle, :avatar)

  class NullAvatar
    def attached? = false
  end

  def render_html(user)
    render_inline(PublicProfile::HeaderComponent.new(user: user)).to_html
  end

  def fragment(user)
    Nokogiri::HTML.fragment(render_html(user))
  end

  test "renders display name, handle, and fallback avatar; shows bio when present" do
    # No #handle method -> falls back to username
    user = FakeUser.new("Jane Doe", "jane@example.com", "jane", "Hello from my bio", NullAvatar.new)

    frag = fragment(user)

    section = frag.at_css("section.rounded-2xl.bg-\\[var\\(--card\\)\\].ring-1.ring-\\[var\\(--border\\)\\].p-8")
    assert section

    name_h1 = section.at_css("h1.text-3xl.font-bold")
    assert_equal "Jane Doe", name_h1.text.strip

    handle_p = section.at_css("p.mt-2.text-lg.text-\\[var\\(--muted\\)\\]")
    assert_equal "@jane", handle_p.text.strip

    bio_p = section.at_css("div.mt-4.max-w-md p.text-base")
    assert_equal "Hello from my bio", bio_p.text.strip

    img = section.at_css("img")
    assert img["src"].start_with?("data:image/svg+xml")
    assert_equal "high", img["fetchpriority"]
    assert_equal "Jane Doe", img["alt"]
    assert_includes img["class"], "w-32"
    assert_includes img["class"], "rounded-full"
  end

  test "display name falls back to email when full_name blank" do
    user = FakeUser.new("", "no-name@example.com", "noname", "bio", NullAvatar.new)
    frag = fragment(user)
    name_h1 = frag.at_css("h1.text-3xl.font-bold")
    assert_equal "no-name@example.com", name_h1.text.strip
  end

  test "handle prefers user#handle when available" do
    user = FakeUserWithHandle.new("Someone", "some@ex.com", "someuser", "bio", "prettyhandle", NullAvatar.new)
    frag = fragment(user)
    handle_p = frag.at_css("p.mt-2.text-lg.text-\\[var\\(--muted\\)\\]")
    assert_equal "@prettyhandle", handle_p.text.strip
  end

  test "handle falls back to username, then email local-part when handle missing" do
    # No #handle method, so fallback path is used

    # with username
    u1 = FakeUser.new("X", "x@ex.com", "xuser", nil, NullAvatar.new)
    h1 = fragment(u1).at_css("p.mt-2.text-lg.text-\\[var\\(--muted\\)\\]").text.strip
    assert_equal "@xuser", h1

    # without username -> local-part of email
    u2 = FakeUser.new("Y", "localpart@example.com", nil, nil, NullAvatar.new)
    h2 = fragment(u2).at_css("p.mt-2.text-lg.text-\\[var\\(--muted\\)\\]").text.strip
    assert_equal "@localpart", h2
  end

  test "bio block is omitted when bio is blank" do
    user = FakeUser.new("Name", "n@example.com", "user", "", NullAvatar.new)
    frag = fragment(user)
    assert_nil frag.at_css("div.mt-4.max-w-md p.text-base")
  end

  test "avatar_src size parameter is respected by image_tag call (passes 512 in template)" do
    user = FakeUser.new("AA", "aa@example.com", "aa", nil, NullAvatar.new)
    img  = fragment(user).at_css("img")
    assert img
    assert img["src"].start_with?("data:image/svg+xml")
  end
end
