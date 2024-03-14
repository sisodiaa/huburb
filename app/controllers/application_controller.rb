class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  before_action :check_user_profile
  before_action :reset_search_state

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      user_profile_path
    else
      dashboard_path('users')
    end
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  protected

  def check_user_profile
    # user_signed_in? to permit unauthenticated requests
    redirect_to new_user_profile_path if user_signed_in? && current_user.profile.nil?
  end

  def reset_search_state
    Search::total_records = nil
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || authenticated_root_path)
  end
end
