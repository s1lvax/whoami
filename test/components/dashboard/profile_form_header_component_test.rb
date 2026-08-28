# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class Dashboard::ProfileFormHeaderComponentTest < ViewComponent::TestCase
  fixtures :users

  def fragment_for(user:, update_href: "/dashboard/profile", cancel_href: "/dashboard/profile/view")
    html = render_inline(
      Dashboard::ProfileFormHeaderComponent.new(user: user, update_href: update_href, cancel_href: cancel_href)
    ).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "renders a multipart PATCH form driven by the avatar-preview controller" do
    frag = fragment_for(user: users(:one))

    form = frag.at_css('form[action="/dashboard/profile"]')
    assert form
    assert_includes form["enctype"].to_s, "multipart/form-data"
    assert_includes form["data-controller"], "avatar-preview"
    assert_includes form["data-controller"], "draft"
    assert form.at_css('input[name="_method"][value="patch"]')
  end

  test "renders initials fallback in the preview image when no avatar is attached" do
    user = users(:one)
    user.avatar.detach if user.avatar&.attached?

    img = fragment_for(user:).at_css('img[data-avatar-preview-target="img"]')
    assert img
    assert img["src"].to_s.start_with?("data:image/svg+xml;utf8,")
  end

  test "file input, remove-avatar checkbox, and helper text" do
    frag = fragment_for(user: users(:one))

    file = frag.at_css('input[type="file"][name="user[avatar]"]')
    assert file
    assert_includes file["accept"].to_s, "image/webp"
    assert_equal "change->avatar-preview#pick", file["data-action"]

    assert frag.at_css('input[type="checkbox"][name="user[remove_avatar]"][value="1"]')
    assert_match(/PNG, JPG, or WEBP up to 5(?:\s| )*MB/, frag.at_css("p.hint").text)
  end

  test "renders inputs prefilled for name, family_name, bio" do
    user = users(:one)
    user.update_columns(name: "Test", family_name: "User", bio: "Hello there")
    frag = fragment_for(user:)

    assert_equal "Test", frag.at_css('input[name="user[name]"]')["value"]
    assert_equal "User", frag.at_css('input[name="user[family_name]"]')["value"]
    assert_equal "Hello there", frag.at_css('textarea[name="user[bio]"]').text
  end

  test "shows bio validation error when present" do
    user = users(:one).dup
    user.errors.add(:bio, "is too long")

    error_p = fragment_for(user:).at_css("p.error")
    assert error_p
    assert_match(/is too long/, error_p.text)
  end

  test "renders submit button and cancel link with turbo-frame target" do
    frag = fragment_for(user: users(:one), cancel_href: "/dashboard/profile/view")

    submit = frag.at_css('button[type="submit"]')
    assert submit
    assert_equal "Save changes", submit.text.strip

    cancel = frag.at_css('a[href="/dashboard/profile/view"]')
    assert cancel
    assert_equal "profile_header", cancel["data-turbo-frame"]
  end
end
