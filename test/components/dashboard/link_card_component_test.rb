require "test_helper"

class Dashboard::LinkCardComponentTest < ViewComponent::TestCase
  # Fake model with minimum for dom_id + routing
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
    component = Dashboard::LinkCardComponent.new(link: link)

    stub_dom_id = "fake_link_#{link.id}"
    stub_delete_path = "/dashboard/favorite_links/#{link.to_param}"

    render_inline(component) do |c|
      # Stub route and dom_id helpers
      c.singleton_class.class_eval do
        define_method(:helpers) do
          @helpers ||= Module.new do
            define_singleton_method(:dashboard_favorite_link_path) { stub_delete_path }
            define_singleton_method(:dom_id) { stub_dom_id }
          end
        end
      end
    end

    Nokogiri::HTML.fragment(rendered_content)
  end

  test "renders label, url and clicks" do
    link = build_link(label: "Rails", url: "https://rubyonrails.org", clicks: 12)
    frag = render_fragment(link:)

    assert_text_includes frag, "Rails"
    assert_text_includes frag, "https://rubyonrails.org"
    assert_text_includes frag, "12"
  end

  test "shows 0 when clicks is nil" do
    link = build_link(clicks: nil)
    frag = render_fragment(link:)

    assert_text_includes frag, "0"
  end

  test "renders delete link with correct path and turbo attributes" do
    link = build_link
    frag = render_fragment(link:)

    delete_link = frag.at_css("a[href='/dashboard/favorite_links/42']")
    assert delete_link
    assert_equal "delete", delete_link["data-turbo-method"]
    assert_equal "Delete this link?", delete_link["data-turbo-confirm"]
    assert_includes delete_link["class"], "inline-flex"
  end

  private

  def assert_text_includes(fragment, expected)
    assert_includes fragment.text, expected
  end
end
