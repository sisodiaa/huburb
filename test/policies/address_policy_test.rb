require 'test_helper'

class AddressPolicyTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @tution_address = addresses(:tution)
  end

  def teardown
    @user = @tution_address = nil
  end

  def test_create
    address_policy = AddressPolicy.new(@user, @tution_address)

    refute address_policy.create?
  end

  def test_update
    pizza_address = addresses(:pizza)

    address_policy1 = AddressPolicy.new(@user, @tution_address)
    address_policy2 = AddressPolicy.new(@user, pizza_address)

    assert address_policy1.update?
    refute address_policy2.update?
  end
end
