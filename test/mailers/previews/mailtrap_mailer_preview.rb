# Preview all emails at http://localhost:3000/rails/mailers/mailtrap_mailer
class MailtrapMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/mailtrap_mailer/welcome_mail
  def welcome_mail
    MailtrapMailer.welcome_mail
  end
end
