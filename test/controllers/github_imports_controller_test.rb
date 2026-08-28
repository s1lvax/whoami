require "test_helper"

class GithubImportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :users

  setup do
    @user = users(:one)
    sign_in @user
    @original_fetch = Github::Client.instance_method(:fetch_user)
  end

  teardown do
    Github::Client.define_method(:fetch_user, @original_fetch)
  end

  test "imports a GitHub profile onto the current user" do
    Github::Client.define_method(:fetch_user) do |_login|
      {
        "login" => "octocat",
        "name" => "Mona Lisa",
        "bio" => "From GitHub",
        "html_url" => "https://github.com/octocat",
        "blog" => nil,
        "twitter_username" => nil,
        "avatar_url" => nil
      }
    end

    post github_import_path, params: { github_login: "octocat" }

    assert_redirected_to dashboard_path
    follow_redirect!
    assert_match "Imported from GitHub", response.body
    @user.reload
    assert_equal "Mona", @user.name
    assert_equal "From GitHub", @user.bio
  end

  test "alerts when GitHub has no such user" do
    Github::Client.define_method(:fetch_user) do |_login|
      raise Github::Client::NotFound
    end

    post github_import_path, params: { github_login: "missing" }

    assert_redirected_to dashboard_path
    follow_redirect!
    assert_match "No GitHub user", response.body
  end

  test "sends an unfinished user with name and username to the avatar step" do
    sign_out @user
    user = users(:two)
    sign_in user

    Github::Client.define_method(:fetch_user) do |_login|
      {
        "login" => "octocat",
        "name" => "Mona Lisa",
        "bio" => "From GitHub",
        "html_url" => "https://github.com/octocat",
        "blog" => nil,
        "twitter_username" => nil,
        "avatar_url" => nil
      }
    end

    post github_import_path, params: { github_login: "octocat" }

    assert_redirected_to onboarding_path(step: "avatar")
  end

  test "sends an unfinished user without a username to the username step" do
    sign_out @user
    user = users(:two)
    user.update_columns(username: nil)
    sign_in user

    Github::Client.define_method(:fetch_user) do |_login|
      {
        "login" => "ab",
        "name" => "Tiny",
        "bio" => nil,
        "html_url" => "https://github.com/ab",
        "blog" => nil,
        "twitter_username" => nil,
        "avatar_url" => nil
      }
    end

    post github_import_path, params: { github_login: "ab" }

    assert_redirected_to onboarding_path(step: "username")
    assert_nil user.reload.username
  end
end
