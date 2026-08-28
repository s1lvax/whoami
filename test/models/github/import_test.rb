require "test_helper"

class Github::ImportTest < ActiveSupport::TestCase
  fixtures :users

  class FakeClient
    def initialize(payload = nil, error: nil)
      @payload = payload
      @error = error
    end

    def fetch_user(_login)
      raise @error if @error
      @payload
    end
  end

  def payload
    {
      "login" => "octocat",
      "name" => "Mona Lisa",
      "bio" => "GitHub mascot",
      "html_url" => "https://github.com/octocat",
      "blog" => "https://octocat.dev",
      "twitter_username" => "monalisa",
      "avatar_url" => nil
    }
  end

  test "fills name, bio, and links from GitHub" do
    user = users(:one)
    user.favorite_links.destroy_all

    result = Github::Import.new(user, "octocat", client: FakeClient.new(payload)).call

    assert result
    user.reload
    assert_equal "Mona", user.name
    assert_equal "Lisa", user.family_name
    assert_equal "GitHub mascot", user.bio
    labels = user.favorite_links.ordered.pluck(:label)
    assert_includes labels, "GitHub"
    assert_includes labels, "Site"
    assert_includes labels, "X"
  end

  test "does not duplicate an existing GitHub link" do
    user = users(:one)
    user.favorite_links.destroy_all
    user.favorite_links.create!(label: "GitHub", url: "https://github.com/octocat")

    Github::Import.new(user, "octocat", client: FakeClient.new(payload)).call

    assert_equal 1, user.favorite_links.where("url LIKE ?", "%github.com/octocat%").count
  end

  test "returns false when GitHub has no such user" do
    user = users(:one)
    result = Github::Import.new(user, "missing", client: FakeClient.new(error: Github::Client::NotFound)).call
    assert_not result
  end

  test "splits a single-word GitHub name without inventing a family name" do
    user = users(:one)
    Github::Import.new(
      user,
      "octocat",
      client: FakeClient.new(payload.merge("name" => "Octocat"))
    ).call

    user.reload
    assert_equal "Octocat", user.name
    assert_nil user.family_name.presence
  end
end
