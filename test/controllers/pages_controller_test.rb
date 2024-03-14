require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @page = pages(:pizza)
    @user = users(:user1)
  end

  def teardown
    @page = @user = nil
  end

  test 'that only owner can edit page' do
    sign_in @user

    delete page_path(@page)

    assert_response :redirect
    assert_redirected_to authenticated_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:alert]

    sign_out :user
  end

  test 'that #show is accessible by unauthenticated users' do
    get page_path(@page)

    assert_response :success
  end

  test 'that unauthenticated user can not access #index' do
    get user_pages_path

    assert_response :redirect
    assert_redirected_to new_user_session_path
    assert_equal 'You need to sign in or sign up before continuing.', flash[:alert]
  end
end
