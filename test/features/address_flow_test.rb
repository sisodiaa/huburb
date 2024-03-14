require "test_helper"

class UserFlowTest < Capybara::Rails::TestCase
  setup do
    Warden.test_mode!
    @user_with_address = users(:user1)
    @user2 = users(:user2)
    @user3 = users(:user3)
    @address = addresses(:no_user)
  end

  teardown do
    @user_with_address = nil
    @user2 = nil
    @address = nil
    @user3 = nil
    Warden.test_reset!
  end

  feature "Address Flow" do
    scenario "presence of marker on map", js: true do
      login_as(@user_with_address, scope: :user)

      visit '/user/profile'

      assert page.has_content?('HUBURB'), 'Brand name is missing'
      within(:xpath, "//div[@id='address-map']") do
        assert page.has_css?("#address-map map area[title='user1']"), 'No marker present'
      end

      logout :user
    end

    scenario "creation of new address for a user", js: true do
      login_as(@user2, scope: :user)

      visit '/user/profile'

      page.find("a.btn.btn-success", text: "Add Address").click

      within(:xpath, "//div[@id='address-new-form']") do
        mark_button = page.find(:xpath, "//input[@class='btn btn-primary btn-block']")
        mark_button.click

        assert page.has_css?("small.help-block", text: "Either line1 or line2 of Address must be present")
        
        fill_in "Address Line 1", with: @address.line1
        fill_in "Address Line 2", with: @address.line2
        fill_in "City", with: @address.city
        fill_in "State", with: @address.state
        fill_in "Country", with: @address.country
        fill_in "Pincode", with: @address.pincode
        mark_button.click
      end

      wait_for_ajax
      assert page.has_css?("#address-map map area[title='#{@user2.username}']"), 'No marker present'

      click_button 'Create Address'

      assert page.has_css?("div.alert", text: "Address was successfully saved.")

      assert page.has_content?(@user2.username)

      logout :user
    end

    scenario "presnce of alert when Google Maps is unable to locate", js: true do
      login_as(@user2, scope: :user)

      visit '/user/address/new'

      within(:xpath, "//div[@id='address-new-form']") do
        mark_button = page.find(:xpath, "//input[@class='btn btn-primary btn-block']")
        
        fill_in "Address Line 1", with: "wiweiru" * 10
        fill_in "Address Line 2", with: "hfkjshf" * 10
        fill_in "City", with: "ksdfhu" * 5
        fill_in "State", with: "amddf" * 5
        fill_in "Country", with: "ewirp" * 5
        fill_in "Pincode", with: "939489" * 3
        mark_button.click
      end

      wait_for_ajax
      refute page.has_css?("#address-map map area[title='#{@user2.username}']"), 'Marker present'

      refute page.has_css?("input[value='Create Address']")
      refute page.has_css?("input[value='Locating...']"), "Locating... button should not be there"
      assert page.has_css?("input[value='Locate on Map']")

      assert page.has_css?("div.alert", text: "Unable to locate, provide a detailed address.")

      logout :user
    end

    scenario "updation of address for a user", js: true do
      login_as(@user_with_address, scope: :user)

      visit '/user/address/edit'

      within(:xpath, "//div[@id='address-edit-form']") do
        assert page.has_css?("input[value='Locate on Map']"), "Locate on Map button is missing"
        assert page.has_css?("input[value='Update Address']"), "Update Address button is missing"
        assert page.has_css?("h5 small", text: "Select \"Locate on Map\" to update marker location"), "\"Locate on Map\" text is missing"

        click_button 'Locate on Map'
      end

      wait_for_ajax
      assert page.has_css?("#address-map map area[title='#{@user_with_address.username}']"), 'No marker present'

      refute page.has_css?("h5 small", text: "Select \"Locate on Map\" to update marker location")

      click_button 'Update Address'

      assert page.has_css?("div.alert", text: "Address was successfully updated.")

      logout :user
    end
  end
end
