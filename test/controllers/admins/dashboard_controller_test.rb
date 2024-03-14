require 'test_helper'

class Admins::DashboardControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = admins(:admin)
    @user = users(:user1)
  end

  def teardown
    @admin = nil
    @user = nil
  end

  test "that admin should be logged in to access dashboard" do
    get dashboard_path('users')

    assert_response :redirect
    assert_redirected_to new_admin_session_path

    sign_in @admin
    get dashboard_path('users')
    assert_response :success
    sign_out :admins
  end

  test "deletion of a user by admin" do
    sign_in @admin
    sign_in @user

    get searches_path
    assert_response :success

    assert session["warden.user.user.key"]

    assert_difference('User.count', -1) do
      assert_difference('Profile.count', -1) do
        assert_difference('Page.count', -3) do
          assert_difference('Address.count', -3) do
            delete dashboard_record_path('users', @user)
          end
        end
      end
    end

    assert_response :redirect
    assert_redirected_to dashboard_path('users')
    assert_equal "Record was successfully deleted", flash[:notice]

    # Check whether session was deleted, if the user was loggedin while his/her account was getting terminated
    refute session["warden.user.user.key"]
  end

  test 'that only non-admin user can not access admin dashboard' do
    sign_in @user

    get dashboard_path('users')

    assert_response :redirect
    assert_redirected_to new_admin_session_path

    sign_out :user
  end
end
