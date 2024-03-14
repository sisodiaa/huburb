require 'test_helper'

class AdvertisementTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers

  def setup
    @ad = advertisements(:discount)
    @pending_ad = advertisements(:accounting_offer)
    @page = pages(:tution)
  end

  def teardown
    @ad = @pending_ad = @page = nil
  end

  test 'that advertisement is valid' do
    assert @ad.valid?
  end

  test 'that headline is present' do
    @ad.headline = ''
    refute @ad.valid?
  end

  test 'that headline is not longer than 50 characters' do
    @ad.headline = 'a' * 51
    refute @ad.valid?
  end

  test 'that body is present' do
    @ad.body = ''
    refute @ad.valid?
  end

  test 'that body is not longer than 140 characters' do
    @ad.body = 'a' * 141
    refute @ad.valid?
  end

  test 'that url is present' do
    assert_nil @ad.url
    assert @ad.valid?
    assert_equal page_path(@page), @ad.url
  end

  test 'that status is given' do
    @ad.status = nil
    refute @ad.valid?
  end

  test 'that status defaults to pending' do
    assert Advertisement.new.pending?
  end

  test 'that status depends on published_at and expired_at dates' do
    @ad.status = 2
    refute @ad.valid?
  end

  test 'that only one published ad can exist at a time' do
    new_ad = @ad.dup
    refute new_ad.valid?
  end

  test 'that only one published ad per page can exist at a time' do
    new_ad = @ad.dup
    new_ad.page = pages(:saloon)
    assert new_ad.valid?
  end

  test '#expired_at returns nil if published_at is nil' do
    @pending_ad.duration = 3
    assert_nil @pending_ad.expired_at
  end

  test '#expired_at returns correct value' do
    @pending_ad.published_at = Time.zone.now
    @pending_ad.duration = 3
    assert_equal @pending_ad.published_at + 3.days, @pending_ad.expired_at
  end

  test '#publish= will publish the ad' do
    assert_nil @pending_ad.published_at
    assert_nil @pending_ad.expired_at
    assert @pending_ad.pending?

    @pending_ad.publish = true

    assert_not_nil @pending_ad.published_at
    assert_not_nil @pending_ad.expired_at
    assert @pending_ad.published?
    refute @pending_ad.pending?
  end

  test 'that duration can not be changed for published ad' do
    original_duration = @ad.duration
    @ad.update_attributes(duration: 5)
    assert_equal original_duration, @ad.reload.duration
  end

  test 'archived ad can not be updated' do
    archived_ad = advertisements(:programming_offer)
    headline = archived_ad.headline
    archived_ad.update_attributes(headline: 'this is a new headline')
    assert_equal headline, archived_ad.reload.headline
  end

  test 'that published ad can not be deleted' do
    refute @ad.destroy
  end

  test 'that location of advertisement is same as that of associated page' do
    new_ad = @page.advertisements.create(
      headline: 'headline',
      body: 'body body',
      duration: 2
    )

    assert_equal @page.address.location, new_ad.reload.location
  end

  test '#not_owned_by' do
    assert_equal 0, Advertisement.not_owned_by(users(:user1)).count
    assert_equal 3, Advertisement.not_owned_by(users(:user2)).count
  end

  test '#nearby' do
    assert_equal 3, Advertisement.nearby('SRID=4326;POINT(77.367573 28.544936)').count
    assert_equal 0, Advertisement.nearby('SRID=4326;POINT(37.367573 58.544936)').count
  end

  test '#published' do
    assert_equal 1, Advertisement.published.count
  end
end
