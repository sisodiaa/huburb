class ApplicationMailer < ActionMailer::Base
  default(from: "Huburb <noreply@huburb.in>")
  layout 'mailer'
end
