class MailtrapMailer < ApplicationMailer
  def welcome_mail(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Welcome to Social Threads! 🎉"
    )
  end
end
