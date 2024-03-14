require "test_helper"

class AdminDashboardTest < Capybara::Rails::TestCase
  def setup
    @admin = admins(:admin)
  end

  def teardown
    @admin = nil
  end

  feature "Admin Dashboard" do
    scenario "Logging In to view users' dashboard and see a record", js: true do
      Capybara.current_driver = :selenium

      visit '/admins/sign_in'
      assert page.has_css?("div#login-form h2", text: "Admin Sign In")

      within(:xpath, "//div[@id='login-form']") do
        fill_in "admin_email", with: @admin.email
        fill_in "admin_password", with: "password"
        click_button "Sign in"
      end

      assert page.has_css?("div.alert", text: "Signed in successfully.")

      records = page.all(:xpath, "//tbody/tr")
      assert_equal 4, records.size

      click_link "#{users(:user1).email}"
      assert page.has_css?("h3", text: "Details of #{users(:user1).email}")
      assert_equal 3, page.all(:xpath, "//tbody/tr[3]/td[2]/a").size

      within(:xpath, "//div[@id='navbar']") do
        click_link 'Logout'
      end

      assert page.has_css?("div.alert", text: "Signed out successfully.")

      Capybara.use_default_driver
    end
  end
end
