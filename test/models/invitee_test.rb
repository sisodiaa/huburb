require 'test_helper'

class InviteeTest < ActiveSupport::TestCase
  def setup
    @invitee = invitees(:first)
  end

  def teardown
    @invitee = nil
  end

  test "that full_name is present" do
    @invitee.full_name = ""
    refute @invitee.valid?
  end

  test "that email is present" do
    @invitee.email = ""
    refute @invitee.valid?
  end

  test "that email format is invalid" do
    @invitee.email = "abex.com"
    refute @invitee.valid?
  end

  test "that email address is unique" do
    duplicate_invitee = @invitee.dup
    duplicate_invitee.email = @invitee.email.upcase
    @invitee.save
    refute duplicate_invitee.valid?
  end
end
