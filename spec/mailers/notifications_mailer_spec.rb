require "rails_helper"

RSpec.describe NotificationsMailer, type: :mailer do
  describe "#customer_order" do
    it "sends to the correct email address" do
      NotificationsMailer.customer_order("test@example.com",
                                         "Jane Doe",
                                         [1, 2, 3]).deliver_later
      email = ActionMailer::Base.deliveries.last

      expect(email.to).to include("test@example.com")
      expect(email.subject).to eq("Your order with Ocho Tickets")
      email.body.parts.each do |part|
        expect(part.to_s).to include(
          "For reference, your order number(s) are: 1, 2, 3.")
      end
    end
  end
end
