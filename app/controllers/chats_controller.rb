# Controller for Chats
class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @page = Page.find_by pin: params[:page_pin]
    authorize @page, :for_chat
  end

  def show
    @room = Room.includes(:pages, :users).find(params[:room])
    authorize @room

    @page = @room.pages.first
  end

  def create
    user = Profile.find_by(username: params[:username]).user || nil
    @page = Page.find_by pin: params[:page_pin] || nil
    @room = Room.create_room(user, @page)
  end
end
