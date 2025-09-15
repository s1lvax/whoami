# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class Onboarding::StepAvatarComponentTest < ViewComponent::TestCase
  fixtures :users

  # Minimal helper so onboarding_path works without real routes
  module TestOnboardingPathHelper
    def onboarding_path(step:)
      "/onboarding?step=#{step}"
    end
  end

  setup do
    ApplicationController.helper(TestOnboardingPathHelper)
  end

  def fragment_for(user:)
    html = render_inline(Onboarding::StepAvatarComponent.new(user: user)).to_html
    Nokogiri::HTML.fragment(html)
  end

  test "renders form to onboarding?step=avatar with PATCH via _method, multipart, and data-turbo=true" do
    user = users(:one)
    frag = fragment_for(user:)

    wrapper = frag.at_css('div[data-controller="avatar-preview"]')
    assert wrapper, "wrapper should have data-controller='avatar-preview'"

    form = wrapper.at_css("form")
    assert form, "form should render"
    assert_equal "/onboarding?step=avatar", form["action"]
    assert_equal "post", form["method"] # Rails uses hidden _method for PATCH
    assert_equal "multipart/form-data", form["enctype"], "form should be multipart for file uploads"
    assert_equal "true", form["data-turbo"]

    method_override = form.at_css('input[name="_method"]')
    assert method_override, "hidden _method should be present"
    assert_equal "patch", method_override["value"]
  end

  test "preview image is hidden with empty src when user has no avatar" do
    user = users(:one)
    user.avatar.detach if user.avatar&.attached?
    frag = fragment_for(user:)

    img = frag.at_css('img[data-avatar-preview-target="img"]')
    assert img, "preview img should be present"
    assert_equal "", img["src"], "src should be empty when no avatar"
    # hidden class present when no avatar
    assert_includes img["class"], "hidden"
  end

  test "preview image shows src and is not hidden when user has an attached avatar" do
    user = users(:one)
    user.avatar.attach(
      io: StringIO.new("fakeimg"),
      filename: "avatar.jpg",
      content_type: "image/jpeg"
    )
    frag = fragment_for(user:)

    img = frag.at_css('img[data-avatar-preview-target="img"]')
    assert img, "preview img should be present"
    # When attached, we render url_for(variant(...)) – src should be non-empty
    refute_equal "", img["src"], "src should be present when avatar is attached"
    refute_includes img["class"], "hidden", "img should not be hidden when avatar attached"
  end

  test "file input has expected attributes (type, name, accept, stimulus data-action, classes)" do
    user = users(:one)
    frag = fragment_for(user:)

    input = frag.at_css('input[type="file"][name="user[avatar]"]')
    assert input, "file input for user[avatar] should be present"

    # Accept matches allowed types from the component template
    assert_equal "image/png,image/jpeg,image/webp", input["accept"]

    # Stimulus action for previewing
    assert_equal "change->avatar-preview#pick", input["data-action"]

    # Basic class hooks (we don't assert the entire class string, just key tokens)
    classes = input["class"].to_s
    %w[bg-[var(--input-bg)] ring-1 ring-[var(--input-border)] rounded-md px-3 py-2].each do |cls|
      assert_includes classes, cls
    end
  end

  test "renders avatar validation error when present" do
    user = users(:one)
    user.errors.add(:avatar, "must be smaller than 5 MB")

    frag = fragment_for(user:)
    error_p = frag.at_css('p.text-xs.text-\\[var\\(--danger\\)\\]')
    assert error_p, "error paragraph should render when user has avatar errors"
    assert_includes error_p.text, "must be smaller than 5 MB"
  end

  test "renders both submit buttons: Continue and Skip for now" do
    user = users(:one)
    frag = fragment_for(user:)
    form = frag.at_css("form")

    continue_btn = form.at_css('button[type="submit"]')
    assert continue_btn
    assert_equal "Continue", continue_btn.text.strip

    skip_btn = form.at_css('button[type="submit"][name="skip"]')
    assert skip_btn
    assert_equal "Skip for now", skip_btn.text.strip
  end
end
