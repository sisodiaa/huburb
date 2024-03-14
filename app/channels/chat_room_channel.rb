# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find(params[:room_id])
    stream_for room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
