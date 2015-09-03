require "rails_helper"
require "factory_helper"

RSpec.describe NotificationsMailer, type: :mailer do
  before do
    build_test_data
  end

  describe "#customer_order" do
    it "sends a customer order confirmation email" do
      order_ids = [1, 2, 3]
      NotificationsMailer.customer_order(@user_1,
                                         order_ids).deliver_later
      email = ActionMailer::Base.deliveries.last

      expect(email.to).to include(@user_1.email)
      expect(email.subject).to eq("Your order with Ocho Tickets")
      email.body.parts.each do |part|
        expect(part.to_s).to include("#{@user_1.full_name},")
        expect(part.to_s).to include(
          "For reference, your order number(s) are: #{order_ids.join(', ')}.")
      end
    end
  end

  describe "#vendor_order" do
    it "sends a vendor order confirmation email" do
      order_id = 1
      NotificationsMailer.vendor_order(@store_admin_1,
                                       @user_1,
                                       order_id).deliver_later
      email = ActionMailer::Base.deliveries.last

      expect(email.to).to include(@store_admin_1.email)
      expect(email.subject).to eq(
        "A new order has been placed through Ocho Tickets")
      email.body.parts.each do |part|
        expect(part.to_s).to include(
          "#{@store_admin_1.full_name},")
        expect(part.to_s).to include(
          "A new order has been placed through Ocho Tickets by #{@user_1.full_name}.")
        expect(part.to_s).to include(
          "For reference, your order number is: #{order_id}.")
      end
    end
  end

  describe "#create_new_account" do
    it "sends a new account creation confirmation email" do
      NotificationsMailer.create_new_account(@user_1).deliver_later
      email = ActionMailer::Base.deliveries.last

      expect(email.to).to include(@user_1.email)
      expect(email.subject).to eq("Welcome to Ocho Tickets!")
      email.body.parts.each do |part|
        expect(part.to_s).to include(
          "Welcome to Ocho Tickets, #{@user_1.full_name}!")
        expect(part.to_s).to include(
          "log in with your email address (#{@user_1.email}) and your password.")
      end
    end
  end

  describe "#create_vendor_account" do
    it "sends a new account creation confiramtion email" do
      NotificationsMailer.create_vendor_account(@store_admin_1).deliver_later
      email = ActionMailer::Base.deliveries.last

      expect(email.to).to include(@store_admin_1.email)
      expect(email.subject).to eq("Welcome to Ocho Tickets!")
      email.body.parts.each do |part|
        expect(part.to_s).to include(
          "Welcome to Ocho Tickets, #{@store_admin_1.full_name}!")
        expect(part.to_s).to include(
          "log in with your email address (#{@store_admin_1.email}) and your password.")
      end
    end
  end
end
