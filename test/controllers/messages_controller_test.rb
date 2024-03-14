require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  def setup
    @user = users(:user1)
    @user3 = users(:user3)
    @room = rooms(:one)
    @message = messages(:message_from_user)
  end

  def teardown
    @user = @message = @user3 = nil
  end

  test 'that a user is logged in' do
    post message_path(@room), params: {
      message: {
        content: 'Hello, There!'
      }
    }, xhr: true

    assert_response :unauthorized
  end

  test '#create for valid message' do
    sign_in @user

    assert_enqueued_with(job: MessageBroadcastJob) do
      post message_path(@room), params: {
        message: {
          content: 'Hello, There!'
        }
      }, xhr: true
    end

    assert_response :ok

    sign_out :user
  end

  test '#create for invalid message' do
    sign_in @user

    assert_no_enqueued_jobs do
      post message_path(@room), params: {
        message: {
          content: ''
        }
      }, xhr: true
    end

    assert_response :success

    sign_out :user
  end

  test '#create for unauthorized access' do
    sign_in @user3

    assert_no_enqueued_jobs do
      post message_path(@room), params: {
        message: {
          content: 'Hello, There!'
        }
      }
    end

    assert_response :redirect
    assert_redirected_to authenticated_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:alert]

    sign_out :user
  end
end
