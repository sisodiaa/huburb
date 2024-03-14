require 'simplecov' if ENV['COVERAGE']

ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require 'capybara/rails'
require 'capybara/poltergeist'
require "minitest/rails/capybara"
require 'selenium-webdriver'

# Uncomment for awesome colorful output
# require "minitest/pride"

################################################################################

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end

class Capybara::Rails::TestCase
  include Warden::Test::Helpers

  def before_teardown
    super
    create_screenshot if failure != nil
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def inject_session(hash)
    Warden.on_next_request do |proxy|
      hash.each do |key, value|
        proxy.raw_session[key] = value
      end
    end
  end

  teardown do
    Capybara.reset_sessions!
  end
end

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || ConnectionPool::Wrapper.new(:size => 1) { retrieve_connection }
  end
end
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

module MutexLockedQuerying
  @@semaphore = Mutex.new

  def async_exec(*)
    @@semaphore.synchronize { super }
  end
end

PG::Connection.prepend(MutexLockedQuerying)

####################################################################################

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(
    app, 
    browser: :chrome
  )
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    inspector: true,
    js_errors: false,
    phantomjs_logger: File.open("log/js.log", "w"),
    window_size: [1440, 900]
  )
end

Capybara.register_driver :poltergeist_mobile do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    inspector: true,
    js_errors: false,
    window_size: [375, 667]
  )
end

Capybara.javascript_driver = :selenium
Capybara.default_driver = :selenium
# Capybara.javascript_driver = :poltergeist
# Capybara.default_driver = :poltergeist

Capybara.server = :puma
Capybara.asset_host = "http://localhost:3000"

#######################################################################################

private
def create_screenshot
  file_name = "#{Date.today.strftime.gsub(/-/,'')}_#{name}_#{SecureRandom.base64.gsub(/\//, '')[0..4]}"
  puts "\nScreenshot saved at " + Capybara.current_session.save_screenshot("../screenshots/#{file_name}.png")
end

def finished_all_ajax_requests?
  page.evaluate_script('jQuery.active').zero?
end
