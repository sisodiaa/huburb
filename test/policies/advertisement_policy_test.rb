require 'test_helper'

class AdvertisementPolicyTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:user1)
    @user2 = users(:user2)
  end

  def teardown
    @user1 = @user2 = nil
  end

  def test_index
    page = pages(:tution)
    ads = page.advertisements

    advertisement_policy1 = AdvertisementPolicy.new(@user1, ads)
    advertisement_policy2 = AdvertisementPolicy.new(@user2, ads)

    assert advertisement_policy1.index?
    refute advertisement_policy2.index?
  end

  def test_create
    ad = advertisements(:discount)

    advertisement_policy1 = AdvertisementPolicy.new(@user1, ad)
    advertisement_policy2 = AdvertisementPolicy.new(@user2, ad)

    assert advertisement_policy1.create?
    refute advertisement_policy2.create?
  end
end
