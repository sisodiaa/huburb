# Preview all emails at http://localhost:3000/rails/mailers/waitlist_mailer
class WaitlistMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/waitlist_mailer/subscribe
  def subscribe
    invitee = Struct.new(:full_name, :email).new('Abhishek Sisodia', 'mail.abhisheksisodia@gmail.com')
    WaitlistMailer.subscribe(invitee)
  end

end
