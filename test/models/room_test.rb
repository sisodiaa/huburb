require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @page = pages(:pizza)
    @room = rooms(:one)
  end

  def teardown
    @user = @page = @room = nil
  end

  test 'that #find_room returns room' do
    assert_equal rooms(:one), Room.find_room(@user, @page)
  end

  test 'that #create_room returns nil when either of member is nil' do
    assert_difference 'Room.count', 0 do
      assert_nil Room.create_room(@user, nil)
    end
  end

  test 'that #create_room returns nil when members are associated' do
    assert_difference 'Room.count', 0 do
      assert_raises(Pundit::NotAuthorizedError) do
        Room.create_room(@user, pages(:breaktym))
      end
    end
  end

  test 'that for valid parameters #create_room returns valid object' do
    assert_difference 'Room.count', 1 do
      assert_not_nil Room.create_room(@user, pages(:barfi))
    end
  end

  test 'that #sender checks if logged in user is sender' do
    assert_equal @user, @room.sender(@user)

    page = pages(:breaktym)
    room = Room.create_room(users(:user2), page)
    assert_equal page, room.sender(@user)
    refute_equal @user, room.sender(@user)
  end

  test 'that #recipient determines who is recipient' do
    assert_equal @page, @room.recipient(@user)
    assert_equal @user, @room.recipient(users(:user2))
  end
end
