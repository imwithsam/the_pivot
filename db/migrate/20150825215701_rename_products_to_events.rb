class RenameProductsToEvents < ActiveRecord::Migration
  def change
    rename_table :products, :events
  end
end
