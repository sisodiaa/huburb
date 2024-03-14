require 'test_helper'

class ChatRoomTest < Capybara::Rails::TestCase
  setup do
    Warden.test_mode!
    @user1 = users(:user1)
    @user2 = users(:user2)
    @user3 = users(:user3)
    @page = pages(:pizza)
    @room = rooms(:one)
  end

  teardown do
    @user1 = @user3 = @page = @room = nil
    Warden.test_reset!
  end

  feature 'ChatRoom' do
    scenario 'Existing chatroom', js: true do
      page.driver.browser.manage.delete_all_cookies

      Capybara.using_session('session_for_user2') do
        login_as(@user2, scope: :user)
        visit "/pages/#{@page.pin}"
      end

      Capybara.using_session('session_for_user1') do
        login_as(@user1, scope: :user)
        visit "/pages/#{@page.pin}"
      end

      Capybara.using_session('session_for_user2') do
        within(:xpath, "//div[@id='chat-rooms-list']") do
          page.find(:xpath, "//div[@id='room-#{@room.id}']/a").click
        end
      end

      Capybara.using_session('session_for_user1') do
        within(:xpath, "//div[@id='chat-panel-form']/form[@id='new_message']") do
          fill_in 'message_content', with: 'This is a feature test'
          click_button 'Send'
        end
      end

      Capybara.using_session('session_for_user2') do
        within(:xpath, "//div[@id='chat-panel-messages']") do
          assert page.has_css?('div.message-card:last-of-type p', text: 'This is a feature test')
        end
      end

      Capybara.using_session('session_for_user1') do
        within(:xpath, "//div[@id='chat-panel-messages']") do
          assert page.has_css?('div.message-card.sender:last-of-type p', text: 'This is a feature test')
        end
      end

      Capybara.using_session('session_for_user2') do
        within(:xpath, "//div[@id='chat-panel-form']/form[@id='new_message']") do
          fill_in 'message_content', with: 'This is a reply'
          click_button 'Send'
        end
      end

      Capybara.using_session('session_for_user1') do
        within(:xpath, "//div[@id='chat-panel-messages']") do
          assert page.has_css?('div.message-card:last-of-type p', text: 'This is a reply')
        end
      end

      Capybara.using_session('session_for_user2') do
        within(:xpath, "//div[@id='chat-panel-messages']") do
          assert page.has_css?('div.message-card.sender:last-of-type p', text: 'This is a reply')
        end
      end

      Capybara.using_session('session_for_user2') do
        logout :user
      end

      Capybara.using_session('session_for_user1') do
        logout :user
      end
    end

    scenario 'Creating chatroom', js: true do
      page.driver.browser.manage.delete_all_cookies

      Capybara.using_session('session_for_user3') do
        login_as(@user3, scope: :user)
        visit "/pages/#{@page.pin}"
      end

      Capybara.using_session('session_for_user2') do
        login_as(@user2, scope: :user)
        visit "/pages/#{@page.pin}"
      end

      Capybara.using_session('session_for_user3') do
        within(:xpath, "//div[@id='chat-panel']") do
          assert page.has_css?("input#button-create-room[value='Chat with #{@page.name}']")
          click_button "Chat with #{@page.name}"
        end
      end

      Capybara.using_session('session_for_user2') do
        page.evaluate_script 'window.location.reload()'
        sleep 3

        room = Room.last
        within(:xpath, "//div[@id='chat-rooms-list']") do
          page.find(:xpath, "//div[@id='room-#{room.id}']/a").click
        end
      end

      Capybara.using_session('session_for_user3') do
        within(:xpath, "//div[@id='chat-panel']") do
          assert page.has_css?('div#chat-panel-form')
          assert page.has_css?('div#chat-panel-messages')
        end
      end

      Capybara.using_session('session_for_user2') do
        within(:xpath, "//div[@id='chat-panel']") do
          assert page.has_css?('div#chat-panel-form')
          assert page.has_css?('div#chat-panel-messages')
        end
      end

      Capybara.using_session('session_for_user3') do
        within(:xpath, "//div[@id='chat-panel-form']/form[@id='new_message']") do
          fill_in 'message_content', with: 'This is a feature test'
          click_button 'Send'
        end
      end

      Capybara.using_session('session_for_user2') do
        within(:xpath, "//div[@id='chat-panel-messages']") do
          assert page.has_css?('div.message-card:last-of-type p', text: 'This is a feature test')
        end
        within(:xpath, "//div[@id='chat-panel-form']/form[@id='new_message']") do
          fill_in 'message_content', with: 'This is a reply'
          click_button 'Send'
        end
      end

      Capybara.using_session('session_for_user3') do
        within(:xpath, "//div[@id='chat-panel-messages']") do
          assert page.has_css?('div.message-card:last-of-type p', text: 'This is a reply')
        end
      end

      Capybara.using_session('session_for_user2') do
        within(:xpath, "//div[@id='chat-panel-messages']") do
          assert page.has_css?('div.message-card.sender:last-of-type p', text: 'This is a reply')
        end

        click_link 'Back to all chats'
        wait_for_ajax
      end

      Capybara.using_session('session_for_user2') do
        refute page.has_css?('a#chat-back', text: 'Back to all chats')
        within(:xpath, "//div[@id='chat-panel']") do
          assert_equal 2, page.all('div.room-list').count
        end

        logout :user
      end
    end
  end
end
