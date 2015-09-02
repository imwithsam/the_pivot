class NotificationsMailer < ApplicationMailer
  def customer_order(customer, order_ids)
    @name = customer.full_name
    @order_ids = order_ids
    subject = "Your order with Ocho Tickets"

    mail(
      to: customer.email,
      subject: subject
    )
  end

  def vendor_order(vendor, customer, order_id)
    @vendor = vendor
    @customer = customer
    @order_id = order_id
    subject = "A new order has been placed through Ocho Tickets"

    mail(
      to: @vendor.email,
      subject: subject
    )
  end

  # Account Creation Email

  # Become a Vendor Email

end
