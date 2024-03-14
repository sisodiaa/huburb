require 'test_helper'

class PicturesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
    @user2 = users(:user2)
    @user3 = users(:user3)
    @page = pages(:breaktym)
  end

  def teardown
    @user = nil
    @user2 = nil
    @page = nil
  end

  test "update action for avatar" do
    sign_in @user2

    patch user_avatar_path, params: {
      avatar: {
        picture: fixture_file_upload('test/fixtures/files/small.jpg', 'image/jpeg')
      }
    }, xhr: true

    assert_response :success

    sign_out :user
  end

  test "invalid update action for avatar" do
    sign_in @user2

    patch user_avatar_path, params: {
      avatar: {
        picture: fixture_file_upload('test/fixtures/files/invalid.jpg', 'image/jpeg')
      }
    }, xhr: true

    assert_response :success
    assert_not_nil @user2.profile.avatar.errors

    sign_out :user
  end

  test "destroy action for avatar" do
    sign_in @user3

    assert_difference 'Picture.count', -1 do
      delete user_avatar_path, xhr: true
    end

    assert_response :success

    sign_out :user
  end

  test "update action for logo" do
    sign_in @user2

    patch page_logo_path(pages(:pizza)), params: {
      logo: {
        picture: fixture_file_upload('test/fixtures/files/small.jpg', 'image/jpeg')
      }
    }, xhr: true

    assert_response :success

    sign_out :user
  end

  test 'other user can not upload image for other page' do
    sign_in @user

    patch page_logo_path(pages(:pizza)), params: {
      logo: {
        picture: fixture_file_upload('test/fixtures/files/small.jpg', 'image/jpeg')
      }
    }, xhr: true

    assert_response :success
    assert_equal 'You are not authorized to perform this action.', flash[:alert]

    sign_out :user
  end

  test "destroy action for logo" do
    sign_in @user2

    assert_difference 'Picture.count', -1 do
      delete page_logo_path(pages(:pizza)), xhr: true
    end

    assert_response :success

    sign_out :user
  end
end
