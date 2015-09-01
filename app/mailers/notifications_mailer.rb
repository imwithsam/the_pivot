class NotificationsMailer < ApplicationMailer
  def contact(to, subject, message)
    @message = message

    mail(
      to: to,
      subject: subject,
      message: @message
    )
  end
end
