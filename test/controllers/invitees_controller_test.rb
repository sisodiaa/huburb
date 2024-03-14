require 'test_helper'

class InviteesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @invitee = invitees(:first)
  end

  def teardown
    @invitee = nil
  end

  test "that invitee count increase on valid submission" do
    assert_difference('Invitee.count') do
      assert_difference 'ActionMailer::Base.deliveries.size', +1 do
        post invitee_path, params: {
          invitee: {
            full_name: "user one",
            email: "user1@example.com"
          }
        }, xhr: true

        invitee_email = ActionMailer::Base.deliveries.last
        assert_equal "Welcome to Huburb!", invitee_email.subject
        assert_equal "user1@example.com", invitee_email.to[0]
      end
    end
  end
end
