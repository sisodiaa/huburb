# AdvertisementsController
class AdvertisementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page, only: %i[index new create]
  before_action :set_ad, only: %i[show edit update destroy]
  before_action :set_page_from_ad, only: %i[show edit update destroy]
  # include CheckPageOwner
  # Change CheckPageOwner concern to CheckOwner

  def index
    @ads = @page
           .advertisements
           .order('created_at DESC')
           .page(params[:page])
           .per(10)
  end

  def show; end

  def new
    @ad = @page.advertisements.new
  end

  def create
    @ad = @page.advertisements.build(advertisement_params)

    if @ad.save
      flash[:notice] = 'Advertisement was successfully created.'
      respond_sjr
    else
      render :new
    end
  end

  def edit; end

  def update
    @publish = advertisement_params.include?(:publish) ? true : false
    if @ad.update(advertisement_params)
      flash[:notice] = update_flash_message
      respond_sjr
    else
      render :edit
    end
  end

  def destroy
    if @ad.destroy
      flash[:notice] = 'Advertisement was successfully destroyed.'
      respond_sjr
    else
      head :bad_request
    end
  end

  private

  def set_page
    @page = Page.find_by pin: params[:page_pin]
    authorize @page, :for_advertisement
  end

  def set_ad
    @ad = Advertisement.find params[:id]
    authorize @ad
  end

  def set_page_from_ad
    @page = @ad.page
  end

  def advertisement_params
    params.require(:advertisement).permit(:headline, :body, :duration, :publish)
  end

  def respond_sjr
    respond_to do |format|
      format.js
    end
  end

  def update_flash_message
    return 'Advertisement was successfully published.' if publishing?
    'Advertisement was successfully updated.'
  end

  def publishing?
    advertisement_params.include?(:publish)
  end
end
