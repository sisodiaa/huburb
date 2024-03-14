require "test_helper"

class SearchesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user2)
  end

  def teardown
    @user = nil
  end

  test "that search is processed even if user address is absent" do
    get searches_path

    assert_response :success
  end
end
