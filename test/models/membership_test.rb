require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  test 'that only two members are allowed per room' do
    room = rooms(:one)
    user = users(:user2)
    member = room.memberships.new(
      memberable_id: user.id,
      memberable_type: 'User'
    )
    refute member.valid?
  end

  test 'that only one user or page per room is allowed' do
    room = Room.create
    user1 = users(:user1)
    user2 = users(:user2)
    page  = pages(:pizza)

    member1 = room.memberships.new(
      memberable_id: user1.id,
      memberable_type: 'User'
    )

    assert member1.save

    member2 = room.memberships.new(
      memberable_id: user2.id,
      memberable_type: 'User'
    )

    assert_not member2.save

    member3 = room.memberships.new(
      memberable_id: page.id,
      memberable_type: 'Page'
    )

    assert member3.save
  end

  test 'that member can not be nil' do
    member = Room.create.memberships.new(memberable: nil)
    refute member.valid?
  end
end
