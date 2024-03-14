require "test_helper"

class PostFlowTest < Capybara::Rails::TestCase
  setup do
    Warden.test_mode!
    @user = users(:user1)
    @page = pages(:tution)
    @post = posts(:welcome)
  end

  teardown do
    @user = @page = @post = nil
    Warden.test_reset!
  end

  feature "Post flow" do
    scenario "CRUD a post", js: true do
      login_as(@user, scope: :user)

      visit "/pages/#{@page.pin}"
      page.find("a.btn.btn-default", text: "Create Post").click

      assert page.has_css?("h2.text-center", text: "Create Post")

      body_text = "This is a filler text which is long enough to get truncated by the rails view helper method."

      within(:xpath, "//form[@id='new_post']") do
        fill_in "Title", with: "Title for testing"
        page.execute_script("document.getElementById('post_body').value = '#{body_text}'");
        click_button "Create Post"
      end

      within(:xpath, "//div[@id='post-container']") do
        assert page.has_css?("h1", text: "Title For Testing")
        assert page.has_content?("#{body_text}")
      end

      page.find("a.btn.btn-default", text: "Posts").click

      wait_for_ajax
      
      within(:xpath, "//div[@id='parent-row']") do
        posts = page.all(:xpath, "//div[@class='trix-content']/small/a")
        assert_equal 5, posts.count

        posts[-1].click
      end

      within(:xpath, "//div[@id='page-logo-section-show']") do
        page.find("a.btn.btn-default", text: "Edit").click
      end

      assert page.has_css?("h2.text-center", text: "Edit Post")

      within(:css, "form[id^='edit_post']") do
        fill_in "Title", with: "Updated title for testing"
        click_button "Update Post"
      end

      within(:xpath, "//div[@id='post-container']") do
        assert page.has_css?("h1", text: "Updated Title For Testing")
      end

      click_link 'Delete'
      page.driver.browser.switch_to.alert.accept

      wait_for_ajax
      
      within(:xpath, "//div[@id='parent-row']") do
        posts = page.all(:xpath, "//div[@class='trix-content']/small/a")
        assert_equal 4, posts.count
      end

      logout :user
    end

    scenario "creating a post with invalid parameters", js: true do
      login_as(@user, scope: :user)

      visit "/pages/#{@page.pin}"
      page.find("a.btn.btn-default", text: "Create Post").click

      assert page.has_css?("h2.text-center", text: "Create Post")

      within(:xpath, "//form[@id='new_post']") do
        fill_in "Title", with: ""
        click_button "Create Post"
      end

      assert page.has_css?("small.help-block", text: "Title can't be blank")

      logout :user
    end
  end
end
