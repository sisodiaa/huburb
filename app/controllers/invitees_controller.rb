class InviteesController < ApplicationController
  def create
    @invitee = Invitee.new(invitees_params)

    if @invitee.save
      WaitlistMailer.subscribe(@invitee).deliver_later
    else
      render :new
    end
  end

  private
  def invitees_params
    params.require(:invitee).permit(:full_name, :email, :city, :description)
  end
end
