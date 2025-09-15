require "test_helper"

class PublicLinksControllerTest < ActionDispatch::IntegrationTest
  fixtures :users, :favorite_links

  def setup
    @user = users(:one)
    @link = favorite_links(:one)
  end

  test "redirects to valid external URL and tracks the click" do
    @link.update!(url: "http://example.com") # ✅ valid

    assert_difference -> { @link.reload.clicks }, 1 do
      get public_link_click_path(username: @user.username, id: @link.id)
      assert_response :redirect
      assert_redirected_to "http://example.com"
    end
  end

  test "redirects to https:// URL without duplication if already normalized" do
    @link.update!(url: "https://rubyonrails.org")

    get public_link_click_path(username: @user.username, id: @link.id)
    assert_response :redirect
    assert_redirected_to "https://rubyonrails.org"
  end

  test "returns 404 for unknown username" do
    get public_link_click_path(username: "ghost", id: @link.id)
    assert_response :not_found
  end
end
