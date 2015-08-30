require "rails_helper"
require "factory_helper"

feature "admin can see all orders" do
  before do
    build_products
    admin = User.create(first_name: "Jane",
                        last_name:  "Doe",
                        username: "Admin Jane",
                        email:      "jane@gmail.com",
                        password:   "password",
                        role:       1)

    platform_role = Role.create(
      name: "platform_admin"
    )

    admin.roles << platform_role

    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(admin)

    @order_1 = Order.create(user_id: @user_1.id,
                            status: "ordered",
                            created_at: DateTime.civil(2015, 07, 05, 21, 33, 0))

    @order_1.event_orders.create(event_id: @event_1.id,
                                quantity: 1,
                                unit_price: @event_1.price)

    @order_2 = Order.create(user_id: @user_1.id,
                            status: "paid",
                            created_at: DateTime.civil(2015, 07, 05, 21, 33, 0))

    @order_2.event_orders.create(event_id: @event_1.id,
                                quantity: 1,
                                unit_price: @event_1.price)

    @order_3 = Order.create(user_id: @user_1.id,
                            status: "cancelled",
                            created_at: DateTime.civil(2015, 07, 05, 21, 33, 0))

    @order_3.event_orders.create(event_id: @event_1.id,
                                quantity: 1,
                                unit_price: @event_1.price)

    @order_4 = Order.create(user_id: @user_1.id,
                            status: "completed",
                            created_at: DateTime.civil(2015, 07, 05, 21, 33, 0))

    @order_4.event_orders.create(event_id: @event_1.id,
                                quantity: 1,
                                unit_price: @event_1.price)

    @order_5 = Order.create(user_id: @user_1.id,
                            status: "completed",
                            created_at: DateTime.civil(2015, 07, 05, 21, 33, 0))


    @order_5.event_orders.create(event_id: @event_1.id,
                                quantity: 1,
                                unit_price: @event_1.price)
  end

  scenario "and the the total number of orders for each status" do
    visit admin_dashboard_path

    expect(current_path).to eq(admin_dashboard_path)

    click_link("View All Orders")

    expect(current_path).to eq(admin_orders_path)

    within("li", text: "Ordered") do
      expect(page).to have_content("1")
    end

    within("li", text: "Paid") do
      expect(page).to have_content("1")
    end

    within("li", text: "Cancelled") do
      expect(page).to have_content("1")
    end

    within("li", text: "Completed") do
      expect(page).to have_content("2")
    end
  end

  scenario "and a link for each individual order" do
    visit admin_orders_path

    expect(current_path).to eq(admin_orders_path)

    within("tr", text: "# #{@order_1.id}") do
      # expect(page).to have_xpath("//a[@href=\"#{admin_order_path(@order_1)}\"]")
      expect(page).to have_content("Ordered")
      expect(page).to have_content("$25.00")
      expect(page).to have_content("July  5, 2015 at  9:33 PM")
    end

    within("tr", text: "# #{@order_2.id}") do
      expect(page).to have_xpath("//a[@href=\"#{admin_order_path(@order_2)}\"]")
      expect(page).to have_content("Paid")
      expect(page).to have_content("$25.00")
      expect(page).to have_content("July  5, 2015 at  9:33 PM")
    end

    within("tr", text: "# #{@order_3.id}") do
      expect(page).to have_xpath("//a[@href=\"#{admin_order_path(@order_3)}\"]")
      expect(page).to have_content("Cancelled")
      expect(page).to have_content("$25.00")
      expect(page).to have_content("July  5, 2015 at  9:33 PM")
    end

    within("tr", text: "# #{@order_4.id}") do
      expect(page).to have_xpath("//a[@href=\"#{admin_order_path(@order_4)}\"]")
      expect(page).to have_content("Completed")
      expect(page).to have_content("$25.00")
      expect(page).to have_content("July  5, 2015 at  9:33 PM")
    end

    within("tr", text: "# #{@order_5.id}") do
      expect(page).to have_xpath("//a[@href=\"#{admin_order_path(@order_5)}\"]")
      expect(page).to have_content("Completed")
      expect(page).to have_content("$25.00")
      expect(page).to have_content("July  5, 2015 at  9:33 PM")
    end

  end

  scenario "and admin can filter orders to display each status type" do
    visit admin_orders_path

    expect(current_path).to eq(admin_orders_path)

    click_link("Ordered 1")

    within("tr", text: "# #{@order_1.id}") do
      expect(page).to have_xpath("//a[@href=\"#{admin_order_path(@order_1)}\"]")
      expect(page).to have_content("Ordered")
      expect(page).to have_content("$25.00")
      expect(page).to have_content("July  5, 2015 at  9:33 PM")
    end

    within("table .order-status") do
      expect(page).not_to have_content("Paid")
      expect(page).not_to have_content("Cancelled")
      expect(page).not_to have_content("Completed")
    end

    click_link("Paid 1")

    within("tr", text: "# #{@order_2.id}") do
      expect(page).to have_xpath("//a[@href=\"#{admin_order_path(@order_2)}\"]")
      expect(page).to have_content("Paid")
      expect(page).to have_content("$25.00")
      expect(page).to have_content("July  5, 2015 at  9:33 PM")
    end

    within("table .order-status") do
      expect(page).not_to have_content("Ordered")
      expect(page).not_to have_content("Cancelled")
      expect(page).not_to have_content("Completed")
    end

    click_link("Cancelled 1")

    within("tr", text: "# #{@order_3.id}") do
      expect(page).to have_xpath("//a[@href=\"#{admin_order_path(@order_3)}\"]")
      expect(page).to have_content("Cancelled")
      expect(page).to have_content("$25.00")
      expect(page).to have_content("July  5, 2015 at  9:33 PM")
    end

    within("table .order-status") do
      expect(page).not_to have_content("Ordered")
      expect(page).not_to have_content("Paid")
      expect(page).not_to have_content("Completed")
    end

    click_link("Completed 2")

    within("tr", text: "# #{@order_4.id}") do
      expect(page).to have_xpath("//a[@href=\"#{admin_order_path(@order_4)}\"]")
      expect(page).to have_content("Completed")
      expect(page).to have_content("$25.00")
      expect(page).to have_content("July  5, 2015 at  9:33 PM")
    end

    status = find("table").first(".order-status").text
    expect(status).not_to eq("Ordered")
    expect(status).not_to eq("Paid")
    expect(status).not_to eq("Cancelled")
  end

  scenario "and there are links to transition the status" do
    visit admin_orders_path

    expect(current_path).to eq(admin_orders_path)

    within("tr", text: "# #{@order_1.id}") do
      expect(page).to have_link("Cancel")
      expect(page).to have_link("Paid")
    end

    within("tr", text: "# #{@order_2.id}") do
      expect(page).to have_link("Cancel")
      expect(page).to have_link("Completed")
    end

    within("tr", text: "# #{@order_3.id}") do
      expect(page).to_not have_link("Ordered")
      expect(page).to_not have_link("Paid")
      expect(page).to_not have_link("Completed")
    end

    within("tr", text: "# #{@order_4.id}") do
      expect(page).to_not have_link("Ordered")
      expect(page).to_not have_link("Paid")
      expect(page).to_not have_link("Cancel")
    end
  end

  scenario "and the status of the orders can be changed" do
    visit admin_orders_path

    within("tr", text: "# #{@order_1.id}") do
      click_link("Paid")
    end

    within("li", text: "Paid") do
      expect(page).to have_content("2")
    end

    within("tr", text: "# #{@order_2.id}") do
      click_link("Completed")
    end

    within("li", text: "Completed") do
      expect(page).to have_content("3")
    end

    within("tr", text: "# #{@order_1.id}") do
      click_link("Cancelled")
    end

    within("li", text: "Cancelled") do
      expect(page).to have_content("2")
    end

  end
end
