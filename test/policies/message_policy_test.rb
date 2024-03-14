require 'test_helper'

class MessagePolicyTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:user1)
    @user3 = users(:user3)
    @message1 = messages(:message_from_user)
  end

  def teardown
    @user1 = @user3 = @message1 = nil
  end

  def test_index
    message_policy1 = MessagePolicy.new(@user1, @message1)
    message_policy2 = MessagePolicy.new(@user3, @message1)

    assert message_policy1.create?
    refute message_policy2.create?
  end
end
