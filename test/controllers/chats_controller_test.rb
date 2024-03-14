require 'test_helper'

class ChatsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
    @other_user = users(:user2)
    @page = pages(:pizza)
    @room1 = rooms(:one)
  end

  def teardown
    @user = @other_user = @page = @room1 = nil
  end

  test 'should get index when logged in' do
    sign_in @other_user

    get page_chats_url(@page)
    assert_response :success

    sign_out :user
  end

  test '#index redirects when accessed by unauthorized user' do
    sign_in @user

    get page_chats_url(@page)
    assert_response :redirect
    assert_redirected_to authenticated_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:alert]

    sign_out :user
  end

  test 'that chat controller can only be accessed by logged in user' do
    get page_chats_url(@page)
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test 'should get show when logged in' do
    sign_in @other_user

    get chatroom_path(@room1)
    assert_response :success

    sign_out :user
  end

  test '#show redirects when accessed by unauthorized user' do
    sign_in users(:user3)

    get chatroom_path(@room1)
    assert_response :redirect
    assert_redirected_to authenticated_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:alert]

    sign_out :user
  end

  test '#create for valid parameters' do
    sign_in @user

    post chatrooms_path(@user.username, @page), xhr: true

    assert_response :success

    sign_out :user
  end

  test 'unauthorized #create' do
    sign_in @user

    post chatrooms_path(@other_user.username, @page), xhr: true

    assert_response :success
    assert_equal 'You are not authorized to perform this action.', flash[:alert]

    sign_out :user
  end
end
