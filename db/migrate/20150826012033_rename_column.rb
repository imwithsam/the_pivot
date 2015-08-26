class RenameColumn < ActiveRecord::Migration
  def change
    rename_column :event_orders, :product_id, :event_id
  end
end
