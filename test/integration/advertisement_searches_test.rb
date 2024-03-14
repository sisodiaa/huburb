require 'test_helper'

class AdvertisementSearchesTest < ActionDispatch::IntegrationTest
  def setup
    @other_user = users(:user2)
    @page = pages(:tution)
    @ad = advertisements(:discount)
    @user2 = users(:user2)
    @user3 = users(:user3)
    @discount_user2 = ad_viewers(:discount_user2)
  end

  def teardown
    @user = @other_user = @page = @ad = @pending_ad = nil
  end

  test '#index' do
    sign_in @user2

    post searches_url, params: {
      longitude: '77.369529',
      latitude: '28.544749'
    }

    assert_equal 30, @discount_user2.view

    get ads_url

    assert_equal 31, @discount_user2.reload.view

    sign_out :user
  end

  test '#show' do
    sign_in @user2

    post searches_url, params: {
      longitude: '77.369529',
      latitude: '28.544749'
    }

    assert_equal 10, @discount_user2.click

    get ad_url(@ad)

    assert_equal 11, @discount_user2.reload.click

    sign_out :user
  end
end
