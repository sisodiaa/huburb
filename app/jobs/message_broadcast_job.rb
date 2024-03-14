# Job for sending message through Action Cable
class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    room = message.room
    ChatRoomChannel.broadcast_to(
      room,
      message: render_message(message, nil),
      sender_type: message.sender.sender_type
    )
  end

  private

  def render_message(message, message_room_sender)
    MessagesController.render(
      partial: 'message',
      locals: {
        message: message,
        message_room_sender: message_room_sender
      }
    )
  end
end
