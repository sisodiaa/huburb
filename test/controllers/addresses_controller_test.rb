require 'test_helper'

class AddressesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
    @user2 = users(:user2)
    @address = addresses(:no_user)
    @page = pages(:saloon)
    @page_with_address = pages(:tution)
  end

  def teardown
    @user = nil
    @user2 = nil
    @address = nil
    @page = nil
    @page_with_address = nil
  end

  test 'that user is redirected to login form if not authenticated' do
    post user_address_path, params: {
      address: {
        pincode: @address.pincode,
        city: @address.city,
        state: @address.state,
        country: @address.country,
        line1: @address.line1,
        line2: @address.line2,
        coordinates: '78.142776 29.927555'
      }
    }, xhr: true

    assert_response :unauthorized
  end

  test 'that Address.Count changes with valid parameters with user' do
    sign_in @user2
    assert_difference('Address.count') do
      post user_address_path, params: {
        address: {
          pincode: @address.pincode,
          city: @address.city,
          state: @address.state,
          country: @address.country,
          line1: @address.line1,
          line2: @address.line2,
          coordinates: '78.142776 29.927555'
        }
      }, xhr: true
    end

    assert_response :success
    assert_equal 'Address was successfully saved.', flash[:notice]

    sign_out :user
  end

  test 'that Address.Count changes with valid parameters with Page' do
    sign_in @user
    assert_difference('Address.count') do
      post page_address_path(@page), params: {
        address: {
          pincode: @address.pincode,
          city: @address.city,
          state: @address.state,
          country: @address.country,
          line1: @address.line1,
          line2: @address.line2,
          coordinates: '78.142776 29.927555'
        }
      }, xhr: true
    end

    assert_response :success
    assert_equal 'Address was successfully saved.', flash[:notice]

    sign_out :user
  end

  test 'that Address.Count remains same with invalid parameters' do
    sign_in @user

    assert_no_difference 'Address.count' do
      post user_address_path, params: {
        address: {
          pincode: @address.pincode,
          city: @address.city,
          state: @address.state,
          country: @address.country,
          coordinates: '78.142776 29.927555'
        }
      }, xhr: true
    end

    assert_response :success

    sign_out :user
  end

  test 'that address for User can be created only once' do
    sign_in users(:user1)

    post user_address_path, params: {
      address: {
        pincode: @address.pincode,
        city: @address.city,
        state: @address.state,
        country: @address.country,
        coordinates: '78.142776 29.927555'
      }
    }

    assert_redirected_to authenticated_root_path
    assert_response :redirect
    assert_equal 'You are not authorized to perform this action.', flash[:alert]

    sign_out :user
  end

  test 'that address for Page can be created only once' do
    sign_in users(:user1)

    post page_address_path(@page_with_address), params: {
      address: {
        pincode: @address.pincode,
        city: @address.city,
        state: @address.state,
        country: @address.country,
        coordinates: '78.142776 29.927555'
      }
    }

    assert_redirected_to authenticated_root_path
    assert_response :redirect
    assert_equal 'You are not authorized to perform this action.', flash[:alert]

    sign_out :user
  end

  test 'only user who is page owner can create address' do
    sign_in @user2
    assert_difference('Address.count', 0) do
      post page_address_path(@page), params: {
        address: {
          pincode: @address.pincode,
          city: @address.city,
          state: @address.state,
          country: @address.country,
          line1: @address.line1,
          line2: @address.line2,
          coordinates: '78.142776 29.927555'
        }
      }, xhr: true
    end

    assert_response :success
    assert_equal 'You are not authorized to perform this action.', flash[:alert]

    sign_out :user
  end

  test 'only user who is page owner can update address' do
    sign_in @user2
    patch page_address_path(@page_with_address), params: {
      address: {
        pincode: '401401'
      }
    }, xhr: true

    assert_response :success
    assert_equal 'You are not authorized to perform this action.', flash[:alert]

    sign_out :user
  end
end
