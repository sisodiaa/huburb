require "test_helper"

class AddressTest < ActiveSupport::TestCase
  setup do
    @address = addresses(:home)
  end

  teardown do
    @address = nil
  end

  def address
    @address ||= Address.new
  end

  def test_valid
    assert address.valid?
  end

  test "that location coordinates can not be left blank" do
    address.location = nil
    refute address.valid?
  end

  test "that city can not be left blank" do
    address.city = nil
    refute address.valid?
  end

  test "that state can not be left blank" do
    address.state = nil
    refute address.valid?
  end

  test "that country can not be left blank" do
    address.country = nil
    refute address.valid?
  end

  test "that either of address line1 or address line2 must be present" do
    address.line1 = ''
    address.line2 = ''
    refute address.valid?, "Either line 1 or line 2 of Address must be present"
  end

  test "that adress is valid if either of address line1 or address line2 is present" do
    address.line2 = nil
    assert address.valid?
  end

  test "that coordinates method will return coordinates for persisted address" do
    assert_not_nil address.coordinates
  end

  test "that coordinates method will return nil for non persisted address" do
    new_address = Address.new
    assert_nil new_address.coordinates
  end
end
