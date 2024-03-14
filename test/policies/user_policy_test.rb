require 'test_helper'

class UserPolicyTest < ActiveSupport::TestCase
  def test_for_address
    user1 = users(:user1)
    user2 = users(:user2)

    user_policy1 = UserPolicy.new(user1, user1)
    user_policy2 = UserPolicy.new(user1, user2)

    assert user_policy1.for_address
    refute user_policy2.for_address
  end
end
