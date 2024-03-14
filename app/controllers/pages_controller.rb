# Page controller
class PagesController < ApplicationController
  include PictureAssociation
  before_action :authenticate_user!, except: %i[show]
  before_action :set_page, only: %i[edit update destroy]
  # include CheckPageOwner

  def index
    @pages = current_user.pages
  end

  def show
    @page = Page.find_by(pin: params[:pin])
    @address = @page.address
    if user_signed_in?
      @page_owner_is_current_user = @page.owner_is_current_user? current_user
      @room = get_room @page_owner_is_current_user
    end
    @posts = @page.posts.recent_five_posts
  end

  def new
    @page = current_user.pages.new
  end

  def create
    @page = current_user.pages.build(page_params)

    if @page.save
      flash[:notice] = 'Page was successfully created.'
      respond_sjr
    else
      render :new
    end
  end

  def edit
    @logo = associated_picture(@page)[1]
  end

  def update
    flash[:notice] = 'Page was successfully updated.'
    respond_sjr if @page.update(page_params)
  end

  def destroy
    @page.destroy

    flash[:notice] = 'Page was successfully destroyed.'
    respond_sjr
  end

  private

  def set_page
    @page = Page.find_by(pin: params[:pin])
    authorize @page
  end

  def page_params
    params.require(:page).permit(:name, :description, :category)
  end

  def respond_sjr
    respond_to do |format|
      format.js
    end
  end

  def get_room(page_owner_is_current_user)
    page_owner_is_current_user ? nil : Room.find_room(@page, current_user)
  end
end
