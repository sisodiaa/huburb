require 'test_helper'

class AdViewerTest < ActiveSupport::TestCase
  def setup
    @user2 = users(:user2)
    @user3 = users(:user3)
    @discount_user2 = ad_viewers(:discount_user2)
  end

  def teardown
    @user2 = @user3 = @discount_user2 = nil
  end

  test 'that AdViewer model is valid' do
    assert @discount_user2.valid?
  end

  test '#views' do
    assert_equal 30, @discount_user2.view

    AdViewer.views(Advertisement.published, @user2)

    assert_equal 31, @discount_user2.reload.view

    AdViewer.views(Advertisement.published, @user3)

    assert_equal 1, AdViewer.order(:created_at).last.view
  end

  test '#clicks' do
    assert_equal 10, @discount_user2.click

    AdViewer.clicks(Advertisement.published, @user2)

    assert_equal 11, @discount_user2.reload.click

    AdViewer.clicks(advertisements(:discount), @user3)

    assert_equal 1, AdViewer.order(:created_at).last.click
  end
end
