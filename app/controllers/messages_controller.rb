# Message controller
class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.find(params[:room])

    @message = @room.messages.build messages_params(@room)
    authorize @message

    if @message.save
      MessageBroadcastJob.perform_later(@message)
      head :ok
    else
      render :new
    end
  end

  private

  def messages_params(room)
    params.require(:message).permit(:content).merge(sender: sender(room))
  end

  def sender(room)
    room.sender(current_user)
  end
end
