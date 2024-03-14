require 'test_helper'

class AdvertisementsSearchesControllerTest < ActionDispatch::IntegrationTest
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

  test 'that only logged in users can view advertisements' do
    get ads_url
    assert_response :redirect
    assert_redirected_to new_user_session_url
  end

  test '#index' do
    sign_in @user

    post searches_url, params: {
      longitude: '77.369529',
      latitude: '28.544749'
    }
    assert_response :success

    get ads_url
    assert_response :success

    sign_out :user
  end

  test '#show' do
    sign_in @user

    get ad_url(@ad), xhr: true

    assert_response :success

    get ad_url(@ad)

    assert_response :redirect
    assert_redirected_to page_path(@page)

    sign_out :user
  end
end
