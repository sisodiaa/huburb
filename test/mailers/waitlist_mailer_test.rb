require 'test_helper'

class WaitlistMailerTest < ActionMailer::TestCase
  test "subscribe" do
    invitee = invitees(:first)
    mail = WaitlistMailer.subscribe(invitees(:first))
    assert_equal "Welcome to Huburb!", mail.subject
    assert_equal [invitee.email], mail.to
    assert_equal ["noreply@huburb.in"], mail.from
  end

end
