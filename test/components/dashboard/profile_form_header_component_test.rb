# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class Dashboard::ProfileFormHeaderComponentTest < ViewComponent::TestCase
  fixtures :users

  def build_user(attrs = {})
    User.create!(
      email: "user#{SecureRandom.hex(3)}@example.com",
      password: "Password!123",
      password_confirmation: "Password!123",
      username: "user#{SecureRandom.hex(2)}",
      name: "Test",
      family_name: "User",
      confirmed_at: Time.current,
      **attrs
    )
  end

  def build_user_with_avatar
    user = build_user
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new("img"),
      filename: "avatar.jpg",
      content_type: "image/jpeg"
    )
    user.avatar.attach(blob)
    user
  end

  def fragment_for(user:, update_href: "/dashboard/profile", cancel_href: "/dashboard/profile/view")
    html = render_inline(
      Dashboard::ProfileFormHeaderComponent.new(
        user: user,
        update_href: update_href,
        cancel_href: cancel_href
      )
    ).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "renders wrapper and a multipart PATCH form" do
    user = users(:one)
    frag = fragment_for(user:)

    section = frag.at_css("section")
    assert section
    section_classes = section["class"].to_s.split
    %w[rounded-xl bg-[var(--surface)] ring-1 ring-[var(--border)] p-6].each { |c| assert_includes section_classes, c }

    form = frag.at_css('form[action="/dashboard/profile"]')
    assert form, "form action should be update_href"
    assert_includes form["enctype"].to_s, "multipart/form-data"
    assert_equal "post", form["method"].to_s.downcase
    assert form.at_css('input[name="_method"][value="patch"]')
  end

  test "renders fallback initials avatar when no avatar is attached" do
    user = users(:one)
    user.avatar.detach if user.avatar&.attached?

    frag = fragment_for(user:)
    preview_img = frag.at_css('img[data-avatar-preview-target="img"]')
    assert preview_img
    assert_equal "", preview_img["src"].to_s
    assert_includes preview_img["class"].to_s, "hidden"

    fallback_img = frag.at_css('img[data-avatar-preview-target="fallback"]')
    assert fallback_img
    assert fallback_img["src"].to_s.start_with?("data:image/svg+xml;utf8,")
  end

  test "file input, remove-avatar checkbox, and helper/error text" do
    user = users(:one)
    frag = fragment_for(user:)

    file = frag.at_css('input[type="file"][name="user[avatar]"]')
    assert file
    assert_includes file["accept"].to_s, "image/png"
    assert_includes file["accept"].to_s, "image/jpeg"
    assert_includes file["accept"].to_s, "image/webp"
    assert_equal "change->avatar-preview#pick", file["data-action"]

    cb = frag.at_css('input[type="checkbox"][name="user[remove_avatar]"][value="1"]')
    assert cb
    assert_includes frag.to_html, "Remove avatar"

    # Find the helper text paragraph without using a CSS class that contains brackets
    helper_text = frag.css("p").find { |p| p.text.include?("PNG, JPG, or WEBP up to") }
    assert helper_text, "expected helper text paragraph"
    # Accept either NBSP or plain space after the number
    assert_match(/PNG, JPG, or WEBP up to 5(?:\s|\u00A0)*MB/, helper_text.text)
  end

  test "renders inputs prefilled for name, family_name, bio" do
    user = users(:one)
    user.update_columns(name: "Test", family_name: "User", bio: "Hello there")
    frag = fragment_for(user:)

    name_input  = frag.at_css('input[name="user[name]"]')
    fam_input   = frag.at_css('input[name="user[family_name]"]')
    bio_textarea = frag.at_css('textarea[name="user[bio]"]')

    assert_equal "Test",  name_input["value"]
    assert_equal "User",  fam_input["value"]
    assert_equal "Hello there", bio_textarea.text
  end

  test "shows bio validation error when present" do
    user = users(:one).dup
    user.errors.add(:bio, "is too long")
    frag = fragment_for(user:)

    error_p = frag.at_css('p.mt-1.text-xs.text-\\[var\\(--danger\\)\\]')
    # Some Rails versions include the attribute name ("Bio is too long")
    assert error_p
    assert_match(/is too long/, error_p.text)
  end

  test "conditionally renders location field only when user responds to :location" do
    user = users(:one)
    frag = fragment_for(user:)
    refute frag.at_css('input[name="user[location]"]')

    user_with_loc = users(:one).dup
    user_with_loc.define_singleton_method(:location) { "Luxembourg" }

    frag2 = fragment_for(user: user_with_loc)
    loc_input = frag2.at_css('input[name="user[location]"]')
    assert loc_input
    assert_equal "Luxembourg", loc_input["value"]
  end

  test "renders submit button and cancel link with turbo-frame target" do
    user = users(:one)
    frag = fragment_for(user:, cancel_href: "/dashboard/profile/view")

    submit_btn = frag.at_css('button[type="submit"]')
    assert submit_btn
    assert_equal "Save changes", submit_btn.text.strip

    cancel = frag.at_css('a[href="/dashboard/profile/view"][data-turbo-frame="profile_header"]')
    assert cancel
    assert_equal "Cancel", cancel.text.strip
  end
end
