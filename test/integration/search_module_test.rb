require "test_helper"

class SearchModuleTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
    set_coordinates
  end

  def teardown
    @user = nil
  end

  test "authorized access" do
    sign_in @user

    get '/search'

    assert_response :success

    get '/search/food'

    assert_response :success

    sign_out :user
  end

  test "public access" do
    get '/search'

    assert_response :success

    get '/search/food'

    assert_response :success
  end
  
  def set_coordinates
    post searches_path, params: {
      longitude: 77.369087,
      latitude: 28.544625
    }
  end
end
