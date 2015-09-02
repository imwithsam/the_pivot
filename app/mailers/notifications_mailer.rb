class NotificationsMailer < ApplicationMailer
  # Customer Email
  def customer_order(email, name, order_ids)
    @name = name
    @order_ids = order_ids

    mail(
      to: email,
      subject: "Your order with Ocho Tickets"
    )
  end

  # Vendor Email
  # Account Creation Email
  # Become a Vendor Email

  def contact(to, subject, message)
    @message = message

    mail(
      to: to,
      subject: subject,
      message: @message
    )
  end
end
