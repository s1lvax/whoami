require "test_helper"

class FavoriteLinkTest < ActiveSupport::TestCase
  fixtures :users

  def setup
    @user = users(:one)
  end

  def build_link(attrs = {})
    defaults = {
      user:  @user,
      label: "Example",
      url:   "https://example.com"
    }
    FavoriteLink.new(defaults.merge(attrs))
  end

  # --- validations -----------------------------------------------------------

  test "valid favorite link saves" do
    link = build_link
    assert link.valid?, -> { link.errors.full_messages.inspect }
  end

  test "requires label unless both label and url are blank" do
    link = build_link(label: "", url: "https://example.com")
    assert_not link.valid?
    assert_includes link.errors[:label], "can't be blank"
  end

  test "requires url unless both label and url are blank" do
    link = build_link(label: "Example", url: "")
    assert_not link.valid?
    assert_includes link.errors[:url], "can't be blank"
  end

  test "allows completely blank label and url (skip mode)" do
    link = build_link(label: "", url: "")
    assert link.valid?, -> { link.errors.full_messages.inspect }
  end

  test "rejects label longer than 40 characters" do
    link = build_link(label: "a" * 41)
    assert_not link.valid?
    assert_includes link.errors[:label], "is too long (maximum is 40 characters)"
  end

  test "rejects invalid url format" do
    [ "ftp://example.com", "not_a_url", "example.com" ].each do |bad|
      link = build_link(url: bad)
      assert_not link.valid?, "expected #{bad.inspect} to be invalid"
      assert_includes link.errors[:url], "must be a valid http(s) URL"
    end
  end

  test "accepts valid http and https URLs" do
    [ "http://example.com", "https://sub.example.com/path" ].each do |good|
      link = build_link(url: good)
      assert link.valid?, -> { link.errors.full_messages.inspect }
    end
  end

  # --- callbacks -------------------------------------------------------------

  test "normalize strips whitespace from label and url" do
    link = build_link(label: "  MyLabel  ", url: "  https://example.com  ")
    link.validate
    assert_equal "MyLabel", link.label
    assert_equal "https://example.com", link.url
  end

  test "user cannot have more than 6 links" do
    @user.favorite_links.destroy_all
    6.times do |i|
      @user.favorite_links.create!(label: "L#{i}", url: "https://example.com/#{i}", position: i)
    end

    extra = build_link(label: "Seventh", url: "https://example.com/7")
    assert_not extra.valid?
    assert_includes extra.errors[:base].join, "6"
  end
end
