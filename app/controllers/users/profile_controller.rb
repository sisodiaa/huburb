class Users::ProfileController < ApplicationController
  include PictureAssociation
  before_action :authenticate_user!
  before_action :set_profile, only: [:edit, :update]
  before_action :redirect_if_profile_exists, only: [:new, :create]
  skip_before_action :check_user_profile, only: [:new, :create]

  def show
    if params.has_key?(:username)
      @profile = Profile.find_by(username: params[:username])
    else
      @profile = current_user.profile
    end

    if @profile && !@profile.user.pending?
    else
      flash[:notice] = "Invalid username: #{params[:username].downcase}"
      @profile = current_user.profile
    end
    @address = @profile.user.address
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = current_user.build_profile(profile_params)
    
    if @profile.save
      flash[:notice] = 'Profile was successfully created.'
      respond_to do |format|
        format.js
      end
    else
      render :new
    end
  end

  def edit
    @avatar = associated_picture(@profile)[1]
  end

  def update
    if @profile.update(profile_params)
      flash[:notice] = 'Profile was successfully updated.'
      respond_to do |format|
        format.js
      end
    else
      render :edit
    end
  end

  private
  def set_profile
    @profile = current_user.profile
  end

  def profile_params
    params.require(:profile)
    .permit(:username, :first_name, :last_name, :gender, :date_of_birth)
  end

  def redirect_if_profile_exists
    unless current_user.profile.nil?
      flash[:alert] = 'Profile already exists.'
      redirect_to user_profile_path
    end
  end
end
