require "test_helper"

class SubscriptionMailerTest < ActionMailer::TestCase
  test "confirm" do
    mail = SubscriptionMailer.confirm
    assert_equal "Confirm", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "welcome" do
    mail = SubscriptionMailer.welcome
    assert_equal "Welcome", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
