require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
    @page = pages(:tution)
    @post = posts(:welcome)
  end

  def teardown
    @post = @page = @user = nil
  end

  test 'that all users can access posts' do
    get page_posts_path(@page)
    assert_response :success

    get page_post_path(@page, @post)
    assert_response :success
  end

  test 'that Post.count changes with valid parameters' do
    sign_in @user

    assert_difference('Post.count') do
      post page_posts_path(@page), params: {
        post: {
          title: 'A title',
          body: 'Body of the post',
          pinned: true
        }
      }, xhr: true
    end

    assert_response :success
    assert_equal 'Post was successfully created.', flash[:notice]

    sign_out :user
  end

  test 'that Post.count does not change with invalid parameters' do
    sign_in @user

    assert_no_difference('Post.count') do
      post page_posts_path(@page), params: {
        post: {
          body: ''
        }
      }, xhr: true
    end

    assert_response :success

    sign_out :user
  end

  test 'should update post' do
    sign_in @user

    put page_post_path(@page, @post), params: {
      post: {
        title: 'New title'
      }
    }, xhr: true

    assert_response :success
    assert_equal 'Post was successfully updated.', flash[:notice]

    sign_out :user
  end

  test 'should delete post' do
    sign_in @user

    assert_difference('Post.count', -1) do
      delete page_post_path(@page, @post), xhr: true
    end

    assert_response :success
    assert_equal 'Post was successfully removed.', flash[:notice]

    sign_out :user
  end

  test 'that only owner can edit/delete a post' do
    sign_in users(:user2)

    delete page_post_path(@page, @post)

    assert_response :redirect
    assert_redirected_to authenticated_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end

  test '#show is accessible to all users' do
    sign_in users(:user2)

    get page_post_path(@page, @post)

    assert_response :success

    get page_posts_path(@page)

    assert_response :success

    sign_out :user
  end

  test 'that Post should belong to Page mentioned in the URL' do
    sign_in @user

    get page_post_path(@page, @post)

    assert_response :success

    sign_out :user
  end

  test 'that accessing Post belonging to wrong Page raises error' do
    sign_in @user

    assert_raises(ActiveRecord::RecordNotFound) do
      get page_post_path(pages(:saloon), @post)
    end

    sign_out :user
  end
end
