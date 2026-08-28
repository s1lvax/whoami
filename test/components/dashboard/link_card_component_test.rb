require "test_helper"

class Dashboard::LinkCardComponentTest < ViewComponent::TestCase
  class FakeLink
    include ActiveModel::Model
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_accessor :id, :label, :url, :clicks

    def persisted? = true
    def to_param = id.to_s
  end

  def build_link(attrs = {})
    FakeLink.new({ id: 42, label: "My Link", url: "https://example.com", clicks: 7 }.merge(attrs))
  end

  def render_fragment(link:)
    render_inline(Dashboard::LinkCardComponent.new(link: link))
    Nokogiri::HTML.fragment(rendered_content)
  end

  test "renders label, host, clicks, and a brand glyph" do
    frag = render_fragment(link: build_link(label: "GitHub", url: "https://github.com/s1lvax", clicks: 12))

    assert_equal "GitHub", frag.at_css(".ws-link-label").text.strip
    assert_equal "github.com", frag.at_css(".ws-link-host").text.strip
    assert_includes frag.at_css(".ws-link-clicks").text, "12"
    assert frag.at_css(".ws-glyph svg.link-glyph")
  end

  test "shows 0 when clicks is nil" do
    frag = render_fragment(link: build_link(clicks: nil))
    assert_includes frag.at_css(".ws-link-clicks").text, "0"
  end

  test "renders edit and delete actions inside the record's turbo frame" do
    link = build_link
    frag = render_fragment(link:)
    frame_id = ActionView::RecordIdentifier.dom_id(link)

    assert frag.at_css("turbo-frame##{frame_id}")
    assert frag.at_css(%Q(a[href="/dashboard/favorite_links/42/edit"][data-turbo-frame="#{frame_id}"]))

    delete_link = frag.at_css('a[href="/dashboard/favorite_links/42"]')
    assert delete_link
    assert_equal "delete", delete_link["data-turbo-method"]
    assert_equal "Delete this link?", delete_link["data-turbo-confirm"]
    assert_equal "Delete My Link", delete_link["aria-label"]
  end
end
