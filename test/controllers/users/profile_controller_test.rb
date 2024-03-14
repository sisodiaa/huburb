require "test_helper"

class Users::ProfileControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
  end

  def teardown
    @user = nil
  end

  test "that profile can not be created if one already exists for the current user" do
    sign_in users(:user_without_profile)

    post user_profile_path, params: {
      profile: {
        username: 'user_without_profile',
        first_name: 'User',
        last_name: 'without profile',
        gender: "male",
        date_of_birth: Date.new(1982, 07, 12)
      }
    }, xhr: true

    assert_response :success
    assert_equal "Profile was successfully created.", flash[:notice]

    post user_profile_path, params: {
      profile: {
        username: 'user_without_profile',
        first_name: 'User',
        last_name: 'without profile',
        gender: "male",
        date_of_birth: Date.new(1982, 07, 12)
      }
    }, xhr: true

    assert_response :success
    assert_equal 'Profile already exists.', flash[:alert]

    sign_out :user
  end

  test "that upon creating a profile, navigation is redirected to page dashboard" do
    sign_in users(:user_without_profile)

    get user_profile_path
    assert_response :redirect

    post user_profile_path, params: {
      profile: {
        username: 'user_without_profile',
        first_name: 'User',
        last_name: 'without profile',
        gender: "male",
        date_of_birth: Date.new(1982, 07, 12)
      }
    }, xhr: true

    assert_response :success
    assert_equal "Profile was successfully created.", flash[:notice]

    sign_out :user
  end

  test "that invalid user and user without address redirects to current user's profile" do
    sign_in @user
    get profiles_path('user555')

    assert_response :success
    assert_equal "Invalid username: user555", flash[:notice]

    sign_out :user
  end
end
