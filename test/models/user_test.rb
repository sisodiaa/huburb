require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:user1)
    @user2 = users(:user2)
  end

  teardown do
    @user = nil
  end

  def user
    @user ||= User.create(
      email: 'user@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  def test_valid
    assert user.valid?
  end

  test 'that user has a profile' do
    assert_equal profiles(:user1), @user.profile
  end

  test 'that profile name is delegated' do
    assert_equal profiles(:user1).username, @user.username
  end

  test 'that user has a address' do
    assert_equal addresses(:home), @user.address
  end

  test 'that user has many pages' do
    assert_not_nil @user.pages
    assert_includes @user.pages, pages(:tution)
    assert_equal @user, pages(:tution).owner
  end

  test 'that pending method returns false for User with profile and address' do
    refute @user.pending?
  end

  test 'chat handle method returns full name for a user' do
    assert_equal 'User One', @user.chat_handle
  end

  test 'sender type returns visitor' do
    assert_equal 'visitor', @user.sender_type
  end

  test 'that #associated_with? checks whether a page is associated' do
    assert @user.associated_with?(pages(:breaktym))
    refute @user.associated_with?(pages(:pizza))
  end
end
