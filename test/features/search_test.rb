require 'test_helper'

class SearchTest < Capybara::Rails::TestCase
  setup do
    Warden.test_mode!
    @user = users(:user1)
    inject_session coordinates: 'POINT (77.369413 28.544845)'
  end

  teardown do
    @user = nil
    Warden.test_reset!
  end

  feature 'Search' do
    scenario 'Peform a public search', js: true do
      visit '/search'
      wait_for_ajax
      sleep 5

      page.find(:xpath, "//a/div[@class='category-box card']/p[@id='name']", text: 'All').click

      assert page.has_css?('div.result-row a', text: 'Coaching Center')
      assert_equal 1, page.all(:xpath, "//div[@id='results-list']/div[@class='result-row col-xs-12 card']").count

      click_link 'Next >'

      assert page.has_css?('div.result-row a', text: 'Breaktym')
      assert_equal 1, page.all(:xpath, "//div[@id='results-list']/div[@class='result-row col-xs-12 card']").count

      click_link 'Next >'

      assert page.has_css?('div.result-row a', text: 'Barfi')
      assert_equal 1, page.all(:xpath, "//div[@id='results-list']/div[@class='result-row col-xs-12 card']").count

      click_link 'Back to Search'

      page.find(:xpath, "//a/div[@class='category-box card']/p[@id='name']", text: 'Clothing').click

      assert page.has_css?('div.result-row', text: 'No search results to display')
    end

    scenario 'Peform a search as logged user', js: true do
      login_as(@user, scope: :user)

      visit '/search'
      wait_for_ajax
      sleep 5

      page.find(:xpath, "//a/div[@class='category-box card']/p[@id='name']", text: 'All').click

      assert page.has_css?('div.result-row a', text: 'Coaching Center')
      assert_equal 1, page.all(:xpath, "//div[@id='results-list']/div[@class='result-row col-xs-12 card']").count

      click_link 'Next >'

      assert page.has_css?('div.result-row a', text: 'Breaktym')
      assert_equal 1, page.all(:xpath, "//div[@id='results-list']/div[@class='result-row col-xs-12 card']").count

      click_link 'Next >'

      assert page.has_css?('div.result-row a', text: 'Barfi')
      assert_equal 1, page.all(:xpath, "//div[@id='results-list']/div[@class='result-row col-xs-12 card']").count

      click_link 'Back to Search'

      page.find(:xpath, "//a/div[@class='category-box card']/p[@id='name']", text: 'Clothing').click

      assert page.has_css?('div.result-row', text: 'No search results to display')

      logout :user
    end
  end
end
