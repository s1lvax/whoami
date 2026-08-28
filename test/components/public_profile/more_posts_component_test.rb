# frozen_string_literal: true

require "test_helper"
require "nokogiri"

class PublicProfile::MorePostsComponentTest < ViewComponent::TestCase
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

  def render_fragment(posts:)
    Nokogiri::HTML.fragment(render_inline(PublicProfile::MorePostsComponent.new(posts: posts)).to_html)
  end

  test "renders a heading and no list when there are no posts" do
    frag = render_fragment(posts: [])
    assert_equal "More writing", frag.at_css("section.more h2").text.strip
    assert_nil frag.at_css("ul")
  end

  test "renders each post as a link row with date and pluralized reads" do
    user = UserStub.new("u")
    p1 = PostStub.new(title: "One", excerpt: "x", views: 1, published_at: Date.new(2025, 9, 1), user: user)
    p2 = PostStub.new(title: "Two", excerpt: "", views: 2, updated_at: Time.new(2025, 9, 10, 10, 0, 0), user: user)

    frag = render_fragment(posts: [ p1, p2 ])
    links = frag.css("section.more ul li a")
    assert_equal 2, links.size
    assert_equal "One", links[0].at_css(".row-title").text.strip
    assert_includes links[0].at_css(".row-sub").text, "1 read"
    assert_includes links[1].at_css(".row-sub").text, "2 reads"
    assert_includes links[0].at_css(".row-sub").text, "September 01, 2025"
  end
end
