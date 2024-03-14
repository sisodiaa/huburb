require 'test_helper'

class PageModuleTest < ActionDispatch::IntegrationTest
  def setup
    @page = pages(:tution)
    @user = users(:user1)
  end

  def teardown
    @page = nil
    @user = nil
  end

  test 'that unauthenticated request to Pages will result in 401' do
    get '/user/pages'

    assert_response :redirect
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_response :success
  end

  test 'that Page is accessible using its PIN' do
    sign_in @user

    get "/pages/#{@page.pin}"

    assert_response :success

    sign_out :user
  end

  test 'that creation of a Page with valid attributes increases Pages count' do
    sign_in @user

    assert_difference('Page.count', 1) do
      post '/user/pages', params: {
        page: {
          name: 'Raja Medical Store',
          description: 'A medicines shop in Lotus Boulevard,
          Sector 100 for providing medicines all day long,
          and deliver medicines at your doorstep at reasonable rates.',
          category: 'medical'
        }
      }, xhr: true
    end

    assert_response :success
    assert_equal 'Page was successfully created.', flash[:notice]

    sign_out :user
  end

  test 'update of a Page' do
    sign_in @user

    patch "/pages/#{@page.pin}", params: {
      page: {
        name: 'Best Coaching Center'
      }
    }, xhr: true

    assert_response :success
    assert_equal 'Page was successfully updated.', flash[:notice]

    sign_out :user
  end

  test 'deletion of a Page' do
    sign_in @user

    assert_difference 'Page.count', -1 do
      assert_difference 'Advertisement.count', -3 do
        delete "/pages/#{@page.pin}", xhr: true
      end
    end

    assert_response :success
    assert_equal 'Page was successfully destroyed.', flash[:notice]

    sign_out :user
  end
end
