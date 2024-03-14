require 'test_helper'

class AdvertisementModuleTest < ActionDispatch::IntegrationTest
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

  test '#create mutates database on valid submission' do
    sign_in @user

    assert_difference 'Advertisement.count', 1 do
      post page_advertisements_url(@page), params: {
        advertisement: {
          headline: 'New ad',
          body: 'Body of new advertisement',
          duration: 1
        }
      }, xhr: true
    end

    assert_equal @page.address.location,
                 Advertisement.order(:created_at).last.location

    sign_out :user
  end

  test '#create does not mutate database on invalid submission' do
    sign_in @user

    assert_difference 'Advertisement.count', 0 do
      post page_advertisements_url(@page), params: {
        advertisement: {
          headline: '',
          body: 'Body of new advertisement',
          duration: 1
        }
      }, xhr: true
    end

    sign_out :user
  end

  test '#destroy' do
    sign_in @user

    assert_difference 'Advertisement.count', -1 do
      delete advertisement_url(@pending_ad), xhr: true
    end

    sign_out :user
  end

  test '#destroy for published ad' do
    sign_in @user

    assert_difference 'Advertisement.count', 0 do
      delete advertisement_url(@ad), xhr: true
    end

    sign_out :user
  end

  test 'publishing of an advertisement with zero published ad' do
    sign_in @user

    assert @pending_ad.pending?
    refute @pending_ad.published?

    @ad.published_at = Time.zone.now - 15.days
    @ad.archived!

    put advertisement_url(@pending_ad), params: {
      advertisement: {
        publish: true
      }
    }, xhr: true

    assert @pending_ad.reload.published?

    sign_out :user
  end

  test 'duration can not be changed for published ad' do
    sign_in @user

    original_duration = @ad.duration

    patch advertisement_url(@ad), params: {
      advertisement: {
        duration: 5
      }
    }, xhr: true

    assert_equal original_duration, @ad.reload.duration

    sign_out :user
  end

  test 'archived ads can not be updated' do
    sign_in @user

    archived_ad = advertisements(:programming_offer)
    headline = archived_ad.headline

    patch advertisement_url(archived_ad), params: {
      advertisement: {
        headline: 'this is a new headline'
      }
    }, xhr: true

    assert_equal headline, archived_ad.reload.headline

    sign_out :user
  end

  test 'other user can not create ad for a page' do
    sign_in @other_user

    assert_difference 'Advertisement.count', 0 do
      post page_advertisements_url(@page), params: {
        advertisement: {
          headline: 'New ad',
          body: 'Body of new advertisement',
          duration: 1
        }
      }, xhr: true
    end

    assert_equal 'You are not authorized to perform this action.', flash[:alert]

    sign_out :user
  end

  test 'other user can not publish ad' do
    sign_in @other_user

    assert @pending_ad.pending?
    refute @pending_ad.published?

    @ad.published_at = Time.zone.now - 15.days
    @ad.archived!

    put advertisement_url(@pending_ad), params: {
      advertisement: {
        publish: true
      }
    }, xhr: true

    refute @pending_ad.reload.published?
    assert @pending_ad.reload.pending?

    assert_equal 'You are not authorized to perform this action.', flash[:alert]

    sign_out :user
  end
end
