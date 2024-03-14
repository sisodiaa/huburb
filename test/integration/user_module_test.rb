require 'test_helper'

class UserModuleTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
  end

  def teardown
    @user = nil
  end

  test "that User.count increase upon registration and new User can log after confirmation" do
    assert_difference('User.count') do
      post user_registration_url,
        params: {
          user: {
            email: 'user@example.com',
            password: 'password',
            password_confirmation: 'password'
          } 
        }, xhr: true
    end

    post user_session_path, params: {
      user: {
        email: 'user@example.com',
        password: 'password'
      }
    }, xhr: true

    assert_response :unauthorized

    confirmation_token = User.last.confirmation_token

    get user_confirmation_path(confirmation_token: confirmation_token)
    follow_redirect!
    assert_response :success
    assert_equal "Your email address has been successfully confirmed.", flash[:notice]

    post user_session_path, params: {
      user: {
        email: 'user@example.com',
        password: 'password'
      }
    }, xhr: true

    assert_response :success
  end

  test "updating password of a user" do
    sign_in @user
    put user_registration_path, params: {
      user: {
        current_password: 'password',
        password: 'dassworp',
        password_confirmation: 'dassworp'
      }
    }, xhr: true

    assert_response :success
    assert_equal "Your account has been updated successfully.", flash[:notice]
    sign_out :user
  end

  test "that login is performed successfully for a user with profile and then logging out" do
    post user_session_path, params: {
      user: {
        email: @user.email,
        password: 'password'
      }
    }, xhr: true

    assert_response :success
    assert_equal "Signed in successfully.", flash[:notice]

    delete destroy_user_session_path, xhr: true
    assert_response :success
    assert_equal "Signed out successfully.", flash[:notice]
  end

  test "that a new user without profile will be redirected to profile creation form post login" do
    user_without_profile = users(:user_without_profile)
    post user_session_path, params: {
      user: {
        email: user_without_profile.email,
        password: 'password'
      }
    }, xhr: true

    assert_response :success
  end

  test "that deleting a user deletes all associated models" do
    sign_in users(:user1)
    assert_difference('User.count', -1) do
      assert_difference('Profile.count', -1) do
        assert_difference('Page.count', -3) do
          assert_difference('Address.count', -3) do
            delete user_registration_path, xhr: true
          end
        end
      end
    end

    assert_response :success
    assert_equal "Bye! Your account has been successfully cancelled. We hope to see you again soon.", 
      flash[:notice]
  end

  test "that password reset instructions are sent" do
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      post user_password_path, params: {
        user: {
          email: users(:user1).email
        }
      }, xhr: true
    end

    reset_email = ActionMailer::Base.deliveries.last
    assert_equal users(:user1).email, reset_email.to[0]
    assert_equal "Reset password instructions", reset_email.subject

    assert_response :success
    assert_equal "You will receive an email with instructions on how to reset your password in a few minutes.",
      flash[:notice]
  end

  test "that no email will be sent for invalid email" do
    assert_difference('ActionMailer::Base.deliveries.size', 0) do
      post user_password_path, params: {
        user: {
          email: 'user1@example'
        }
      }, xhr: true
    end
    assert_response :success
  end

  test "password reset using password controller" do
    put user_password_path, params: {
      user: {
        password: 'dassworp',
        password_confirmation: 'dassworp',
        reset_password_token: users(:user1).send_reset_password_instructions
      }
    }, xhr: true

    assert_response :success
    assert_equal "Your password has been changed successfully. You are now signed in.", flash[:notice]
  end
end
