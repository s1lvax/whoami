# frozen_string_literal: true

require "test_helper"

class CtaComponentTest < ViewComponent::TestCase
  include Rails.application.routes.url_helpers

  test "invites a sign up without fake social proof" do
    html = render_inline(CtaComponent.new).to_html

    assert_includes html, "Make yours"
    assert_includes html, new_user_registration_path
    refute_includes html, "already using Whoami"
    refute_includes html, "bg-red-500"
    refute_includes html, "join creators"
    assert_includes html, "landing-cta-band"
  end
end
