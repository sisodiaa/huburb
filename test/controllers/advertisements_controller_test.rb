require 'test_helper'

class AdvertisementsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
    @other_user = users(:user2)
    @page = pages(:tution)
    @ad = advertisements(:discount)
    @pending_ad = advertisements(:accounting_offer)
  end

  def teardown
    @user = @other_user = @page = @ad = @pending_ad = nil
  end

  test 'that only logged user access advertisements controller' do
    get page_advertisements_url(@page)
    assert_response :redirect
    assert_redirected_to new_user_session_url

    sign_in @user

    get page_advertisements_url(@page)
    assert_response :success

    sign_out :user
  end

  test '#show' do
    sign_in @user

    get advertisement_url(@ad)

    assert_response :success

    sign_out :user
  end

  test '#new' do
    sign_in @user

    get new_page_advertisement_url(@page)

    assert_response :success

    sign_out :user
  end

  test '#edit' do
    sign_in @user

    get edit_advertisement_url(@ad)

    assert_response :success

    sign_out :user
  end

  test '#create for valid submission' do
    sign_in @user

    post page_advertisements_url(@page), params: {
      advertisement: {
        headline: 'New ad',
        body: 'Body of new advertisement',
        duration: 1
      }
    }, xhr: true

    assert_response :success
    assert_equal 'Advertisement was successfully created.', flash[:notice]

    sign_out :user
  end

  test '#create for invalid submission' do
    sign_in @user

    post page_advertisements_url(@page), params: {
      advertisement: {
        headline: '',
        body: 'Body of new advertisement',
        duration: 1
      }
    }, xhr: true

    assert_response :success
    assert_match(/has-error/, @response.body)

    sign_out :user
  end

  test '#update for valid submission' do
    sign_in @user

    put advertisement_url(@ad), params: {
      advertisement: {
        headline: 'updated headline'
      }
    }, xhr: true

    assert_response :success
    assert_equal 'Advertisement was successfully updated.', flash[:notice]

    sign_out :user
  end

  test '#update for invalid submission' do
    sign_in @user

    put advertisement_url(@ad), params: {
      advertisement: {
        headline: ''
      }
    }, xhr: true

    assert_response :success
    assert_match(/has-error/, @response.body)

    sign_out :user
  end

  test '#destroy' do
    sign_in @user

    delete advertisement_url(@pending_ad), xhr: true

    assert_response :success
    assert_equal 'Advertisement was successfully destroyed.', flash[:notice]
    sign_out :user
  end

  test '#destroy for published ad' do
    sign_in @user

    delete advertisement_url(@ad), xhr: true

    assert_response :bad_request

    sign_out :user
  end

  test 'publishing of an advertisement with one published ad' do
    sign_in @user

    put advertisement_url(@pending_ad), params: {
      advertisement: {
        publish: true
      }
    }, xhr: true

    assert_response :success

    sign_out :user
  end

  test 'publishing of an advertisement with zero published ad' do
    sign_in @user

    @ad.published_at = Time.zone.now - 15.days
    @ad.archived!

    put advertisement_url(@pending_ad), params: {
      advertisement: {
        publish: true
      }
    }, xhr: true

    assert_response :success
    assert_equal 'Advertisement was successfully published.', flash[:notice]

    sign_out :user
  end

  test '#update redirects for valid submission by other user' do
    sign_in @other_user

    put advertisement_url(@ad), params: {
      advertisement: {
        headline: 'updated headline'
      }
    }

    assert_response :redirect
    assert_redirected_to authenticated_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:alert]

    sign_out :user
  end

  test 'that other user can create published ad for his page' do
    sign_in @other_user

    page = pages(:barfi)

    post page_advertisements_url(page), params: {
      advertisement: {
        headline: 'headline',
        body: 'body',
        duration: 2
      }
    }, xhr: true

    assert_response :success
    assert_equal 'Advertisement was successfully created.', flash[:notice]

    put advertisement_url(page.advertisements.first), params: {
      advertisement: {
        publish: true
      }
    }, xhr: true

    assert_response :success
    assert_equal 'Advertisement was successfully published.', flash[:notice]

    sign_out :user
  end

  test '#show redirects for other users' do
    sign_in @other_user

    get advertisement_url(@ad)

    assert_response :redirect
    assert_redirected_to authenticated_root_path
    assert_equal 'You are not authorized to perform this action.', flash[:alert]

    sign_out :user
  end
end
