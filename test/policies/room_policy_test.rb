require 'test_helper'

class RoomPolicyTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:user1)
    @user2 = users(:user2)
    @room1 = rooms(:one)
    @room_policy1 = RoomPolicy.new(@user1, @room1)
    @room_policy2 = RoomPolicy.new(@user2, @room1)
  end

  def teardown
    @user1 = @user2 = @room1 = @room_policy1 = @room_policy2 = nil
  end

  def test_index?
    refute @room_policy1.index?
    assert @room_policy2.index?
  end

  def test_show?
    room_policy3 = RoomPolicy.new(users(:user3), @room1)

    assert @room_policy1.show?
    assert @room_policy2.show?
    refute room_policy3.show?
  end
end
