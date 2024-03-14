require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @message_from_user = messages(:message_from_user)
  end

  def teardown
    @message_from_user = nil
  end

  test 'that message content is present' do
    @message_from_user.content = ''
    refute @message_from_user.valid?
  end

  test 'that message should belongs to a room' do
    @message_from_user.room = nil
    refute @message_from_user.valid?
  end

  test 'that message should have a sender' do
    @message_from_user.sender = nil
    refute @message_from_user.valid?
  end
end
