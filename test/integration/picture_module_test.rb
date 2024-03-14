require 'test_helper'

class PictureModuleTest < ActionDispatch::IntegrationTest
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

  test "that avatar files larger than 5MB are invalid" do
    sign_in @user

    assert_difference 'Picture.count', 0 do
      post user_avatar_path, params: {
        avatar: {
          picture: fixture_file_upload('test/fixtures/files/invalid.jpg', 'image/jpeg')
        }
      }, xhr: true
    end

    assert_response :success

    sign_out :user
  end

  test "that avatar files smaller than or equal to 5MB are valid" do
    sign_in @user

    assert_difference 'Picture.count', 1 do
      post user_avatar_path, params: {
        avatar: {
          picture: fixture_file_upload('test/fixtures/files/valid.jpg', 'image/jpeg')
        }
      }, xhr: true
    end

    assert_response :success

    sign_out :user
  end

  test "that logo files larger than 5MB are invalid" do
    sign_in @user

    assert_difference 'Picture.count', 0 do
      post page_logo_path(@page), params: {
        logo: {
          picture: fixture_file_upload('test/fixtures/files/invalid.jpg', 'image/jpeg')
        }
      }, xhr: true
    end

    assert_response :success

    sign_out :user
  end

  test "that logo file smaller than or equal to 5MB is valid" do
    sign_in @user

    assert_difference 'Picture.count', 1 do
      post page_logo_path(@page), params: {
        logo: {
          picture: fixture_file_upload('test/fixtures/files/valid.jpg', 'image/jpeg')
        }
      }, xhr: true
    end

    assert_response :success

    sign_out :user
  end
end
