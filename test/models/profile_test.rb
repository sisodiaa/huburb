require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  setup do
    @profile = profiles(:user1)
  end

  teardown do
    @profile = nil
    @genders = nil
  end

  def profile
    @profile ||= Profile.new
  end

  def test_valid
    assert profile.valid?
  end

  test "that Profile has one of the predefined gender value" do
    genders = ["male", "female"]
    assert_includes genders, @profile.gender
  end

  test "that Profile with a valid gender value is valid" do
    @profile.gender = :male
    assert @profile.valid?
  end

  test "that Profile with NIL Gender value is not valid" do
    @profile.gender = nil
    refute @profile.valid?
  end

  test "that assigning undefined Gender value to Profile will raise an error" do
    assert_raises RuntimeError do
      Profile.genders[:undefined] = 999
    end
  end

  test "that Profile without username is invalid" do
    @profile.username = ""
    refute @profile.valid?
  end

  test "that Profile without first_name is invalid" do
    @profile.first_name = ""
    refute @profile.valid?
  end

  test "that Profile saves username in downcase" do
    mixed_case_username = "uSeR1"
    @profile.username = mixed_case_username
    @profile.save
    assert_equal mixed_case_username.downcase, @profile.reload.username
  end

  test "that Profile username is unique" do
    duplicate_profile = @profile.dup
    duplicate_profile.username = @profile.username.upcase
    refute duplicate_profile.valid?
  end
end
