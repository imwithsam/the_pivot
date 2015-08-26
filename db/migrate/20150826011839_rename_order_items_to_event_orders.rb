class RenameOrderItemsToEventOrders < ActiveRecord::Migration
  def change
    rename_table :order_items, :event_orders
  end
end
