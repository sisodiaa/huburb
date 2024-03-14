require 'test_helper'

class AdvertisementFlowTest < Capybara::Rails::TestCase
  setup do
    Warden.test_mode!
    @user1 = users(:user1)
    @user2 = users(:user2)
    @page = pages(:tution)
    @published_ad = advertisements(:discount)
    @pending_ad = advertisements(:accounting_offer)
    inject_session coordinates: 'POINT (77.369413 28.544845)'
  end

  teardown do
    @user1 = @user2 = @page = @published_ad = @pending_ad = nil
    Warden.test_reset!
  end

  feature 'AdvertisementFlow' do
    scenario 'Non-owner user can not create ad for a page', js: true do
      login_as(@user2, scope: :user)

      visit "/pages/#{@page.pin}/advertisements/new"

      assert page.has_css?('li.list-group-item a', text: 'Manage Profile')

      logout :user
    end

    scenario 'Simple CRUD for advertisement resource', js: true do
      login_as(@user1, scope: :user)

      visit "/pages/#{@page.pin}"

      click_link 'Advertisement Dashboard'

      assert page.has_css?('div#create-ad-button a.btn', text: 'Create Advertisement')

      click_link 'Create Advertisement'

      assert page.has_css?('h1.text-center', text: 'Create Advertisement')

      within(:xpath, "//form[@id='new_advertisement']") do
        click_button 'Create Advertisement'

        assert page.has_css?(
          'small.help-block',
          text: "Headline is too short (minimum is 1 character) and can't be blank"
        )
        assert page.has_css?(
          'small.help-block',
          text: "Body is too short (minimum is 1 character) and can't be blank"
        )

        fill_in 'advertisement_headline', with: 'This is a test headline'
        fill_in 'advertisement_body', with: 'This is a test body'
        page.find('#advertisement_duration').find("option[value='2']").select_option

        click_button 'Create Advertisement'
      end

      within(:xpath, "//div[@class='card ad-container']") do
        assert page.has_css?('a strong', text: 'This is a test headline')
        assert page.has_css?('a p', text: 'This is a test body')
      end

      within(:xpath, "//div[@class='col-md-5 table-responsive']") do
        assert page.has_css?('td strong', text: 'Headline')
        assert page.has_css?('td', text: 'This is a test headline')
        assert page.has_css?('td', text: '2 days')
      end

      click_link 'Edit'

      this_ad = Advertisement.order(:created_at).last

      within(:xpath, "//form[@id='edit_advertisement_#{this_ad.id}']") do
        fill_in 'advertisement_headline', with: ''
        click_button 'Update Advertisement'
        assert page.has_css?(
          'small.help-block',
          text: "Headline is too short (minimum is 1 character) and can't be blank"
        )

        fill_in 'advertisement_headline', with: 'This is an updated test headline'
        click_button 'Update Advertisement'
      end

      within(:xpath, "//div[@class='card ad-container']") do
        assert page.has_css?('a strong', text: 'This is an updated test headline')
      end

      within(:xpath, "//div[@class='col-md-5 table-responsive']") do
        assert page.has_css?('td', text: 'This is an updated test headline')
      end

      click_link 'Delete'
      page.driver.browser.switch_to.alert.accept

      assert page.has_css?('a.btn', text: 'Create Advertisement')

      logout :user
    end

    scenario '#show for a published advertisement', js: true do
      login_as(@user1, scope: :user)

      visit "/advertisements/#{@published_ad.id}"

      refute page.has_css?('input.btn.btn-success'), 'No Publish button for published ad'
      refute page.has_css?('a.btn.btn-danger'), 'No Delete button for published ad'
      assert page.has_css?('a.btn.btn-default'), 'Only Edit button for published ad'

      click_link 'Edit'

      assert page.has_css?('select#advertisement_duration[disabled]'), 'Duration non-editable for published ad'

      logout :user
    end

    scenario 'publishing a pending ad', js: true do
      login_as(@user1, scope: :user)

      visit "/advertisements/#{@pending_ad.id}/edit"

      within(:xpath, "//form[@id='edit_advertisement_#{@pending_ad.id}']") do
        page.find('#advertisement_duration').find("option[value='3']").select_option
        click_button 'Update Advertisement'
      end

      within(:xpath, "//div[@class='col-md-5 table-responsive']") do
        assert page.has_css?('td strong', text: 'Duration')
        assert page.has_css?('td', text: '3 days')
      end

      click_button 'Publish'

      assert page.has_css?('h2', text: 'Preview')
      assert page.has_css?('.alert.alert-danger', text: 'Only one advertisement can be published at a time.')

      @published_ad.published_at = Time.zone.now - 15.days
      @published_ad.archived!

      click_button 'Publish'

      assert page.has_css?('.alert.alert-info', text: 'Advertisement was successfully published.')

      logout :user
    end

    scenario 'ads dashboard', js: true do
      login_as(@user1, scope: :user)

      visit "/pages/#{@page.pin}/advertisements"
      assert page.has_css?('div#create-ad-button a.btn', text: 'Create Advertisement')

      # check for tables with control buttons
      within(:xpath, "//table[@id='ad-dashboard-table']") do
        assert_equal 3, page.all(:xpath, "//table[@id='ad-dashboard-table']/tbody/tr").count
        assert_equal 3, page.all(:xpath, "//div[@class='btn-group']/a[@class='btn btn-xs btn-default'][1]").count
        assert_equal 3, page.all(:xpath, "//div[@class='btn-group']/a[@class='btn btn-xs btn-default'][2]").count
        assert_equal 2, page.all(:xpath, "//div[@class='btn-group']/a[@class='btn btn-xs btn-default'][3]").count
        assert_equal 1, page.all(:xpath, "//form[@class='button_to']/input[@class='btn btn-xs btn-success']").count

        assert page.has_css?("tr[data-ad='#{@published_ad.id}'] td.text-center", text: @published_ad.ad_viewers.sum(:view))
        assert page.has_css?("tr[data-ad='#{@published_ad.id}'] td.text-center", text: @published_ad.ad_viewers.sum(:click))

        page.find(:xpath, "//form[@class='button_to']/input[@class='btn btn-xs btn-success']").click
      end

      assert page.has_css?('.alert.alert-danger', text: 'Only one advertisement can be published at a time.')

      logout :user
    end

    scenario 'show ads to visitors', js: true do
      login_as(@user2, scope: :user)

      visit '/ads'

      within(:xpath, "//div[@id='ad-results']") do
        assert_equal 1, page.all('div.ad-container').count
        page.find('div.ad-container a').click
      end

      assert page.has_content?(@page.description)

      logout :user
    end

    scenario "user's own ad will not come in searches", js: true do
      login_as(@user1, scope: :user)

      visit '/ads'

      within(:xpath, "//div[@id='ad-results']") do
        assert_equal 0, page.all('div.ad-container').count
      end

      logout :user
    end
  end
end
