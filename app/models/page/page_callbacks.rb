require 'random_string'

class Page::PageCallbacks
  include RandomString
  class << self
    def before_create page
      page.pin = loop do
        pin = RandomString::generate_pin 6
        break pin unless page.class.exists?(pin: pin)
      end
    end
  end
end
