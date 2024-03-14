# Preview all emails at http://localhost:3000/rails/mailers/user_management_mailer
class UserManagementMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    UserManagementMailer.confirmation_instructions(User.first, "faketoken", {})
  end

  def reset_password_instructions
    UserManagementMailer.reset_password_instructions(User.first, "faketoken", {})
  end
end
