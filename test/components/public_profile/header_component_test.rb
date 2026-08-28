# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class PublicProfile::HeaderComponentTest < ViewComponent::TestCase
  FakeUser = Struct.new(:full_name, :email, :username, :bio, :avatar)
  FakeUserWithHandle = Struct.new(:full_name, :email, :username, :bio, :handle, :avatar)

  class NullAvatar
    def attached? = false
  end

  def fragment(user)
    Nokogiri::HTML.fragment(render_inline(PublicProfile::HeaderComponent.new(user: user)).to_html)
  end

  test "renders display name, handle, and bio" do
    user = FakeUser.new("Jane Doe", "jane@example.com", "jane", "Hello from my bio", NullAvatar.new)
    frag = fragment(user)

    assert_equal "Jane Doe", frag.at_css("h1").text.strip
    assert_includes frag.text, "@jane"
    assert_includes frag.text, "Hello from my bio"
    assert_nil frag.at_css(".poster-photo"), "no photo means no photo block"
    assert frag.at_css(".poster-hero.b-id .page-name"), "name sits in the poster hero"
  end

  test "display name falls back to email when full_name blank" do
    user = FakeUser.new("", "no-name@example.com", "noname", "bio", NullAvatar.new)
    assert_equal "no-name@example.com", fragment(user).at_css("h1").text.strip
  end

  test "handle prefers user#handle when available" do
    user = FakeUserWithHandle.new("Someone", "some@ex.com", "someuser", "bio", "prettyhandle", NullAvatar.new)
    assert_includes fragment(user).text, "@prettyhandle"
  end

  test "handle falls back to username, then email local-part" do
    u1 = FakeUser.new("X", "x@ex.com", "xuser", nil, NullAvatar.new)
    assert_includes fragment(u1).text, "@xuser"

    u2 = FakeUser.new("Y", "localpart@example.com", nil, nil, NullAvatar.new)
    assert_includes fragment(u2).text, "@localpart"
  end

  test "bio is omitted when blank" do
    user = FakeUser.new("Name", "n@example.com", "user", "", NullAvatar.new)
    html = fragment(user).to_html
    assert_includes html, "Name"
    refute_includes fragment(user).at_css("h1").parent.to_html, "bio"
    assert_nil fragment(user).at_css("[data-bio]")
  end
end
