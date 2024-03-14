class WaitlistMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.waitlist_mailer.subscribe.subject
  #
  def subscribe(invitee)
    @full_name = invitee.full_name

    mail to: invitee.email,
      subject: "Welcome to Huburb!"
  end
end
