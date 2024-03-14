require "test_helper"

class HomepageTest < Capybara::Rails::TestCase
  def setup
    @invitee = invitees(:first)
  end

  def teardown
    @invitee = nil
  end

  feature "Homepage" do
    scenario "A visitor request for the invite", js: true do
      skip
      visit "/"

      page.find(:xpath, "//li/a[@class='cta-link']").click
      
      click_button "Submit"

      assert page.has_css?("small.help-block", text: "Full Name can't be blank")

      within(:xpath, "//div[@id='invitee-popup-form']/form") do
        fill_in "invitee_full_name", with: "user one"
        fill_in "invitee_email", with: "user1@example.com"
        click_button "Submit"
      end

      within(:xpath, "//div[@id='invitee-popup']") do
        assert page.has_css?("h3", text: "Thanks for your interest in Huburb")
      end
    end
  end
end
