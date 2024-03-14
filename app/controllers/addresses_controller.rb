class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_locatable
  before_action :redirect_path, only: [:create, :update]
  before_action :set_address, only: [:edit, :update]

  def new
    @address = Address.new(locatable_type: @locatable.class.to_s, locatable_id: @locatable.id)
  end
  
  def create
    @address = Address.find_by(locatable: @locatable) || @locatable.build_address(address_params)
    authorize @address

    if @address.save
      flash[:notice] = 'Address was successfully saved.'
      respond_to do |format|
        format.js { @redirect_path = redirect_path }
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if params[:commit] == 'Update Address' && @address.update(address_params)
      flash[:notice] = 'Address was successfully updated.'
      respond_to do |format|
        format.js { @redirect_path = redirect_path }
      end
    else
      render :edit
    end
  end

  private
  def set_locatable
    @locatable = find_locatable
    authorize @locatable, :for_address
  end

  def redirect_path
    @locatable.class == Page ? page_path(@locatable) : user_profile_path
  end

  def find_locatable
    params.each do |name, value|
      if name =~ /page/
        return Page.find_by(pin: value)
      end
    end
    current_user
  end

  def set_address
    @address = @locatable.address
  end

  def address_params
    params.require(:address).permit(:pincode, :city, :state, :country, :line1, :line2, :coordinates)
  end
end
