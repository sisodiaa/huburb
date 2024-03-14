require "test_helper"

class PageFlowTest < Capybara::Rails::TestCase
  setup do
    Warden.test_mode!
    @user = users(:user1)

    @page = pages(:tution)
    @other_page = pages(:saloon)
  end

  teardown do
    @user = nil
    @page = nil
    @other_page = nil
    Warden.test_reset!
  end

  feature "Page Flow" do
    scenario "unsuccessfull attempt to create a page", js: true do
      login_as(@user, scope: :user)

      visit '/user/pages/new'
      assert page.has_content?("Add Page")

      within(:xpath, "//form[@id='new_page']") do
        fill_in "Name", with: "Choco Moco"
        fill_in "Description", with: ""
        page.find("#page_category").find("option[value='food']").select_option
        click_button "Create Page"
      end

      assert page.has_css?("small.help-block", text: "Description can't be blank")

      logout :user
    end

    scenario "create, show, update, and delete a Page", js: true do
      login_as(@user, scope: :user)

      visit '/user/profile'

      page.find(:xpath, "//li[@class='dropdown']/a[@class='dropdown-toggle']").click
      assert page.has_css?("ul.dropdown-menu li a", text: "Manage Pages"), "Manage Pages link is missing"
      within("ul.dropdown-menu") do
        click_link "Manage Pages"
      end

      assert page.has_css?("div.page-list-heading", text: "Published")
      assert page.has_css?("div.page-list-heading", text: "Pending")
      assert page.has_css?("a.btn.btn-success", text: "Create Page")
      refute page.has_css?("a.btn.btn-default", text: "Pages")
      page.find("a.btn.btn-success", text: "Create Page").click

      assert page.has_content?("Add Page")

      within("form#new_page") do
        fill_in "Name", with: "Choco Mocho"
        fill_in "Description", with: "At the heart of Chocomocho is attention to detail and this essence can be felt in everything we do.
        Driven by sheer passion and yearn for exotic taste, our chocolates are not run-of-the mill."
        page.find("#page_category").find("option[value='food']").select_option
        click_button "Create Page"
      end

      assert page.has_css?("div.alert", text: "Page was successfully created.")
      page.find("a.btn.btn-default", text: "Pages").click

      within(:xpath, "//div[@id='page-card-#{@page.pin}']") do
        click_link "Edit"
      end

      within(:css, "form[id^='edit_page']") do
        fill_in "Name", with: "Choco Mocho Pocho"
        click_button "Update Page"
      end

      assert page.has_css?("div.alert", text: "Page was successfully updated.")

      click_link 'Delete'
      page.driver.browser.switch_to.alert.accept

      assert page.has_css?("a.btn.btn-success", text: "Create Page")

      logout :user
    end

    scenario "CRUD an Address associated with a Page", js: true do
      login_as(@user, scope: :user)

      visit '/user/pages'

      within(:xpath, "//div[@id='page-card-#{@other_page.pin}']") do
        click_link 'Add Address'
      end

      within(:xpath, "//form[@id='new_address']") do
        fill_in "Address Line 1", with: "Shop #1, Planet Lotier"
        fill_in "Address Line 2", with: "Lotus Boulevard, Sector 100"
        fill_in "City", with: "Noida"
        fill_in "State", with: "Uttar Pradesh"
        fill_in "Country", with: "India"
        fill_in "Pincode", with: "201304"
        click_button "Locate on Map"
      end

      wait_for_ajax
      assert page.has_css?("#address-map map area[title='#{@user.username}']"), 'No marker present'

      click_button 'Create Address'

      assert page.has_css?("div.alert", text: "Address was successfully saved.")

      wait_for_ajax
      assert page.has_css?("#address-map map area[title='#{@other_page.name}']"), 'No marker present'

      page.find("a.btn.btn-default", text: "Edit").click

      page.find("div#settings-list > a", text: "Address").click

      within(:css, "form[id^='edit_address']") do
        fill_in "Address Line 1", with: "Shop #11, Planet Lotier"
        click_button 'Update Address'
      end

      assert page.has_css?("div.alert", text: "Address was successfully updated.")

      logout :user
    end

    scenario 'A guest visting a page', js: true do
      visit "/pages/#{@page.pin}"

      within(:xpath, "//div[@id='posts-panel']") do
        assert_equal 4, page.all(:xpath, "//div[@class='post-panel']").count
        assert_equal 2, page.all(:xpath, "//span[@class='label label-default']").count
        within(:xpath, "//div[@class='post-panel'][1]") do
          assert page.has_css?('span.label-default', text: 'Pinned')
        end
      end

      assert page.has_css?('div#page-description h5 strong', text: 'Description')
      assert page.has_css?('div#chat-panel-log-in a.btn', text: "Log in to chat with #{@page.name.titleize}")
    end
  end
end
