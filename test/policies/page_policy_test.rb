require 'test_helper'

class PagePolicyTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:user1)
    @user2 = users(:user2)
    @page = pages(:tution)
  end

  def teardown
    @user1 = @user2 = @page = nil
  end

  def test_update
    page_policy1 = PagePolicy.new(@user1, @page)
    page_policy2 = PagePolicy.new(@user2, @page)

    assert page_policy1.update?
    refute page_policy2.update?
  end
end
