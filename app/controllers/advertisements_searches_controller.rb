class AdvertisementsSearchesController < ApplicationController
  before_action :authenticate_user!

  def index
    @ads = Advertisement
           .not_owned_by(current_user)
           .nearby(current_user_location)
           .published
           .order('published_at DESC')
           .page(params[:page])
           .per(10)

    AdViewer.views(@ads, current_user)
  end

  def show
    ad = Advertisement.find params[:id]
    AdViewer.clicks(ad, current_user)
    @page = ad.page
    respond_to do |format|
      format.js
      format.html do
        redirect_to @page
      end
    end
  end

  private

  def current_user_location
    "SRID=4326;#{session[:coordinates]}"
  end
end
