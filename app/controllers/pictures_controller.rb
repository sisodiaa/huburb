class PicturesController < ApplicationController
  include PictureAssociation

  before_action :authenticate_user!
  before_action :set_imageable, only: [:create, :update, :destroy]
  before_action :redirect_path, only: [:create, :update]
  before_action :set_picture, only: [:update, :destroy]

  def create
    @picture = @imageable.build_picture(picture_params)
    
    if @picture.save
      flash[:notice] = "#{@imageable.picture_association.to_s.titleize} was successfully created."
      respond_to do |format|
        format.js { @redirect_path = redirect_path }
      end
    else
      respond_to do |format|
        format.js { render :new }
      end
    end
  end
  
  def edit
  end

  def update
    if @picture.update(picture_params)
      flash[:notice] = "#{@imageable.picture_association.to_s.titleize} was successfully updated."
      respond_to do |format|
        format.js { @redirect_path = redirect_path }
      end
    else
      respond_to do |format|
        format.js { render :edit }
      end
    end
  end

  def destroy
    @picture.destroy
    respond_to do |format|
      format.js do
        @picture = @imageable.build_picture
        render :destroy
      end
    end
  end


  private
  def picture_params
    params.require(@imageable.picture_association).
      permit(:picture, :viewport_x, :viewport_y, :viewport_width, 
             :viewport_height, :viewport_pic_w, :viewport_pic_h)
  end

  def set_imageable
    @imageable = find_imageable
    authorize @imageable, :for_picture if @imageable.instance_of? Page
  end

  def find_imageable
    params.each do |name, value|
      if name =~ /page/
        return Page.find_by(pin: value)
      end
    end
    current_user.profile
  end

  def set_picture
    @picture = @imageable.picture
  end

  def redirect_path
    @imageable.class == Page ? page_path(@imageable) : user_profile_path
  end
end
