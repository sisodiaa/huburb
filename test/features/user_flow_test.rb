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

  feature "User Flow" do
    scenario "sign up of a new user, creation of profile, and then navigating to user profile page", js: true do
      visit '/users/sign_up'
      
      assert page.has_css?("form#new_user")
      within(:xpath, "//div[@id='signup-form']/div[@class='card']/form[@id='new_user']") do
        fill_in "user[email]", with: ""
        fill_in "user[password]", with: ""
        fill_in "user[password_confirmation]", with: ""
        click_button "Sign up"
      end

      assert page.has_content?("Email can't be blank")
      assert page.has_content?("Password can't be blank")

      within(:xpath, "//div[@id='signup-form']/div[@class='card']/form[@id='new_user']") do
        fill_in "user[email]", with: "user100@example.com"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "ueuyweriuyweruyuy"
        click_button "Sign up"
      end

      assert page.has_content?("Password Confirmation doesn't match Password")

      within(:xpath, "//div[@id='signup-form']/div[@class='card']/form[@id='new_user']") do
        fill_in "user[email]", with: "user100@example.com"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
        click_button "Sign up"
      end

      assert page.has_content?("A message with a confirmation link has been sent to your email address.")

      confirmation_token = User.last.confirmation_token

      visit "/users/confirmation/?confirmation_token=#{confirmation_token}"

      within(:xpath, "//div[@id='login-form']/div[@class='card margin-bottom-15']/form[@id='new_user']") do
        fill_in "user[email]", with: "user100@example.com"
        fill_in "user[password]", with: "password"
        click_button "Sign in"
      end

      refute page.has_css?("div#signup-progress")
      refute page.has_css?("h3", text: "Profile")
      refute page.has_css?("h5", text: "In-Progress")

      within(:xpath, "//form[@id='new_profile']") do
        click_button 'Create Profile'
      end

      assert page.has_css?("small.help-block", text: "Username can't be blank")

      within(:xpath, "//form[@id='new_profile']") do
        fill_in "profile[username]", with: "user100"
        fill_in "profile[first_name]", with: "User"
        fill_in "profile[last_name]", with: "Hundred"
        find("option[value='female']").click
        page.find('#profile_date_of_birth').set("1983-10-05")
        click_button 'Create Profile'
      end

      assert page.has_css?("div.alert", text: "Profile was successfully created.")

      refute page.has_css?("div#signup-progress")
      assert page.has_css?("a.btn", text: "Create Page")
      refute page.has_css?("div.page-list-heading", text: "Published")
      refute page.has_css?("div.page-list-heading", text: "Pending")
    end

    scenario "Updating a profile", js: true do
      login_as(@user_with_address, scope: :user)

      visit '/user/profile'

      page.find(:xpath, "//li[@class='dropdown']/a[@class='dropdown-toggle']").click
      click_link "Manage Account"
      page.find(:xpath, "//div[@id='settings-list']/a[@class='list-group-item '][1]", text: "Profile").click

      within("form[action*='profile']") do
        fill_in "profile[first_name]", with: ""
        click_button 'Update Profile'
      end

      assert page.has_css?("small.help-block", text: "First Name can't be blank")

      within("form[action*='profile']") do
        fill_in "profile[first_name]", with: "yuzer"
        click_button 'Update Profile'
      end

      assert page.has_css?("div.alert", text: "Profile was successfully updated.")

      page.find(:xpath, "//li[@class='dropdown']/a[@class='dropdown-toggle']").click
      click_link "Logout"
      assert page.has_css?("form#new_user")
      
      logout :user
    end

    scenario "visiting another user's profile", js: true do
      login_as(@user_with_address, scope: :user)

      visit "/profiles/#{@user3.username}"

      assert page.has_css?("h4", text: @user3.username)
      refute page.has_css?("h4", text: @user_with_address.username)
    end

    scenario "change password", js: true do
      visit '/users/sign_in'

      within(:xpath, "//form[@id='new_user']") do
        fill_in "user_email", with: @user_with_address.email
        fill_in "user_password", with: 'password'
        click_button 'Sign in'
      end

      assert page.has_css?("div.alert", text: "Signed in successfully.")

      page.find(:xpath, "//li[@class='dropdown']/a[@class='dropdown-toggle']").click
      click_link 'Manage Account'

      within(:xpath, "//form[@id='edit_user']") do
        fill_in "user_current_password", with: ""
        click_button "Update"
      end

      assert page.has_css?("small.help-block", text: "Current Password can't be blank")

      within(:xpath, "//form[@id='edit_user']") do
        fill_in "user_current_password", with: "password"
        fill_in "user_password", with: "dassworp"
        fill_in "user_password_confirmation", with: "dassworp"
        click_button "Update"
      end

      assert page.has_css?("div.alert", text: "Your account has been updated successfully.")

      page.find(:xpath, "//li[@class='dropdown']/a[@class='dropdown-toggle']").click
      click_link 'Logout'

      assert page.has_css?("div.alert", text: "Signed out successfully."), "Signed out flash message is missing"

      visit '/users/sign_in'

      within(:xpath, "//form[@id='new_user']") do
        fill_in "user_email", with: @user_with_address.email
        fill_in "user_password", with: 'password'
        click_button 'Sign in'
      end

      assert page.has_css?("div.alert", text: "Invalid Email or password.")

      within(:xpath, "//form[@id='new_user']") do
        fill_in "user_email", with: @user_with_address.email
        fill_in "user_password", with: 'dassworp'
        click_button 'Sign in'
      end

      assert page.has_css?("div.alert", text: "Signed in successfully.")
    end

    scenario "delete account", js: true do
      visit '/users/sign_in'

      within(:xpath, "//form[@id='new_user']") do
        fill_in "user_email", with: @user3.email
        fill_in "user_password", with: 'password'
        click_button 'Sign in'
      end

      assert page.has_css?("div.alert", text: "Signed in successfully.")

      page.find(:xpath, "//li[@class='dropdown']/a[@class='dropdown-toggle']").click
      click_link 'Manage Account'

      click_button 'Delete Account'
      page.driver.browser.switch_to.alert.accept

      assert page.has_css?("div.alert", text: "Bye! Your account has been successfully cancelled. We hope to see you again soon.")
    end

    scenario "content of navbar is same for all users with a profile", js: true do
      login_as(@user_with_address, scope: :user)

      visit '/user/pages'

      within(:xpath, "//div[@class='container']/div[@id='navbar']") do
        assert_equal 4, page.all(:css, "ul.nav > li").count

        assert page.has_css?("li > a", text: "SEARCH")
        assert page.has_css?("li > a", text: @user_with_address.username.upcase)
        assert page.has_css?("li.dropdown")
      end

      logout :user

      login_as(@user2, scope: :user)

      visit '/user/pages'

      within(:xpath, "//div[@class='container']/div[@id='navbar']") do
        assert_equal 4, page.all(:css, "ul.nav > li").count

        assert page.has_css?("li > a", text: "SEARCH")
        assert page.has_css?("li > a", text: @user2.username.upcase)
        assert page.has_css?("li.dropdown")
      end

      logout :user
    end
  end
end
