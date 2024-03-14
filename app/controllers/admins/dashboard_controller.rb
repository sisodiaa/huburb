class Admins::DashboardController < ApplicationController
  layout "admin_dashboard"
  before_action :authenticate_admin!
  before_action :set_model
  before_action :find_record, only: [:show, :destroy]

  def index
    @records = @model.order(:id).page(params[:page])
  end

  def show
  end

  def destroy
    @record.destroy
    sign_out(@record) if @model == User
    flash[:notice] = "Record was successfully deleted"
    if @model == User
      redirect_to dashboard_path('users')
    else
      redirect_to dashboard_path('pages')
    end
  end

  private
  def set_model
    @model = find_model params[:model]
  end

  def find_record
    @record = if @model == Page
                @model.find_by(pin: params[:record])
              else
                @model.find(params[:record])
              end
  end

  def find_model model
    case model
    when 'users'
      User
    when 'pages'
      Page
    when 'invitees'
      Invitee
    else
      nil
    end
  end
end
