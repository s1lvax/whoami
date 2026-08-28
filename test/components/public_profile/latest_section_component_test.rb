# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class PublicProfile::LatestPostsSectionComponentTest < ViewComponent::TestCase
  UserStub = Struct.new(:username)

  class PostStub
    attr_reader :title, :excerpt, :views, :published_at, :updated_at, :user
    def initialize(title:, excerpt:, views:, published_at: nil, updated_at: Time.current, user:)
      @title        = title
      @excerpt      = excerpt
      @views        = views
      @published_at = published_at
      @updated_at   = updated_at
      @user         = user
    end
  end

  def render_fragment(user:, posts:, pagy:)
    Nokogiri::HTML.fragment(
      render_inline(
        PublicProfile::LatestPostsSectionComponent.new(user: user, posts: posts, pagy: pagy)
      ).to_html
    )
  end

  test "renders nothing when there are no posts" do
    pagy = Pagy::Offset.new(count: 0, page: 1, limit: 10)
    html = render_inline(
      PublicProfile::LatestPostsSectionComponent.new(user: UserStub.new("tester"), posts: [], pagy: pagy)
    ).to_html
    assert_equal "", html.strip
  end

  test "renders post titles, excerpts, dates, and a count" do
    user = UserStub.new("tester")
    t1 = Date.new(2025, 9, 1)
    post1 = PostStub.new(title: "First Post", excerpt: "Short excerpt here", views: 1, published_at: t1, user: user)
    post2 = PostStub.new(title: "Second Post", excerpt: "", views: 2, updated_at: Time.new(2025, 9, 10, 10, 0, 0), user: user)
    pagy = Pagy::Offset.new(count: 2, page: 1, limit: 10)

    frag = render_fragment(user: user, posts: [ post1, post2 ], pagy: pagy)
    text = frag.text.gsub(/\s+/, " ")

    assert_includes text, "First Post"
    assert_includes text, "Second Post"
    assert_includes text, "Short excerpt here"
    refute_match(/No posts yet/, text)

    assert_equal 2, frag.css("li.row").size
    assert_equal "2", frag.at_css(".card-head .count").text.strip
    assert_equal "Sep 2025", frag.at_css("li.row .row-when").text.strip
  end
end
