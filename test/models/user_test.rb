
require "test_helper"

class UserTest < ActiveSupport::TestCase
  fixtures :users

  def build_user(attrs = {})
    defaults = {
      email: "person#{SecureRandom.hex(3)}@example.com",
      password: "Password!123",
      password_confirmation: "Password!123",
      username: "user#{SecureRandom.hex(2)}",
      name: "Jane",
      family_name: "Doe",
      confirmed_at: Time.current
    }
    User.new(defaults.merge(attrs))
  end

  # --- validations -----------------------------------------------------------

  test "valid user saves" do
    user = build_user
    assert user.valid?, -> { user.errors.full_messages.inspect }
  end

  # Username behavior (nil allowed until onboarding, blank not allowed)
  test "username can be nil before onboarding" do
    user = build_user(username: nil)
    assert user.valid?, -> { user.errors.full_messages.inspect }
  end

  test "username cannot be blank string" do
    user = build_user(username: "")
    assert_not user.valid?
    assert_includes user.errors[:username], "can't be blank"
  end

  test "uppercased usernames are auto-downcased" do
    user = build_user(username: "UPPER")
    user.validate
    assert user.valid?
    assert_equal "upper", user.username
  end

  test "rejects invalid username format" do
    [ "ab", "with-hyphen", "with space", "!!!" ].each do |bad|
      user = build_user(username: bad)
      assert_not user.valid?, "expected #{bad.inspect} to be invalid"
      assert_includes user.errors[:username].join, "must be 3–30 chars"
    end
  end

  test "accepts valid username format" do
    %w[abc abc123 john1doe user007].each do |good|
      user = build_user(username: good)
      assert user.valid?, -> { user.errors.full_messages.inspect }
    end
  end

  test "rejects reserved usernames" do
    User::RESERVED_USERNAMES.each do |reserved|
      user = build_user(username: reserved)
      assert_not user.valid?, "#{reserved.inspect} should be reserved"
      assert_includes user.errors[:username], "is reserved"
    end
  end

  test "username must be unique case-insensitive" do
    existing = users(:one)
    user = build_user(username: existing.username.upcase)
    assert_not user.valid?
    assert_includes user.errors[:username], "has already been taken"
  end

  test "name is required and max length 80" do
    user = build_user(name: "")
    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"

    long = "a" * 81
    user = build_user(name: long)
    assert_not user.valid?
    assert_includes user.errors[:name], "is too long (maximum is 80 characters)"
  end

  test "family_name is required and max length 80" do
    user = build_user(family_name: "")
    assert_not user.valid?
    assert_includes user.errors[:family_name], "can't be blank"

    long = "a" * 81
    user = build_user(family_name: long)
    assert_not user.valid?
    assert_includes user.errors[:family_name], "is too long (maximum is 80 characters)"
  end

  test "bio must be <= 280 chars" do
    user = build_user(bio: "a" * 281)
    assert_not user.valid?
    assert_includes user.errors[:bio], "is too long (maximum is 280 characters)"
  end

  # --- callbacks -------------------------------------------------------------

  test "downcases username before validation" do
    user = build_user(username: "MiXeDCasE")
    user.validate
    assert_equal "mixedcase", user.username
  end

  # --- instance methods ------------------------------------------------------

  test "onboarded? true when onboarded_at set" do
    user = build_user(onboarded_at: Time.current)
    assert user.onboarded?
  end

  test "onboarded? false when onboarded_at nil" do
    user = build_user(onboarded_at: nil)
    assert_not user.onboarded?
  end

  test "full_name joins name and family_name" do
    user = build_user(name: "Jane", family_name: "Doe")
    assert_equal "Jane Doe", user.full_name
  end

  test "full_name omits blanks" do
    user = build_user(name: "Solo", family_name: nil)
    assert_equal "Solo", user.full_name
  end

  test "handle returns username if present" do
    user = build_user(username: "coolname")
    assert_equal "coolname", user.handle
  end

  test "handle falls back to email local-part if username missing" do
    user = build_user(username: nil, email: "someone@example.com")
    assert_equal "someone", user.handle
  end

  # --- avatar attachment -----------------------------------------------------

  test "rejects invalid avatar type" do
    user = build_user
    user.avatar.attach(
      io: StringIO.new("hello"),
      filename: "file.txt",
      content_type: "text/plain"
    )
    assert_not user.valid?
    assert_includes user.errors[:avatar], "must be PNG, JPG, or WEBP"
  end

  test "rejects oversized avatar" do
    user = build_user
    user.avatar.attach(
      io: StringIO.new("0" * (6.megabytes)),
      filename: "big.jpg",
      content_type: "image/jpeg"
    )
    assert_not user.valid?
    assert_includes user.errors[:avatar], "must be smaller than 5 MB"
  end

  test "accepts valid avatar" do
    user = build_user
    user.avatar.attach(
      io: StringIO.new("img"),
      filename: "ok.jpg",
      content_type: "image/jpeg"
    )
    assert user.valid?, -> { user.errors.full_messages.inspect }
  end
end
