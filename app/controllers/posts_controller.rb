class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_page
  # include CheckPageOwner
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = @page.posts.order('id DESC').page(params[:page])
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = @page.posts.build(post_params)

    if @post.save
      flash[:notice] = 'Post was successfully created.'
      respond_to do |format|
        format.html { redirect_to page_posts_path(@page) }
        format.js
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = 'Post was successfully updated.'
      respond_to do |format|
        format.js
      end
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = 'Post was successfully removed.'
    respond_to do |format|
      format.js
    end
  end

  private
  def set_page
    @page = Page.find_by(pin: params[:page_pin])
    authorize @page, :for_post unless action_is_show_or_index?
  end

  def set_post
    @post = @page.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :pinned)
  end
  
  def action_is_show_or_index?
    action_name == 'show' || action_name == 'index'
  end
end
