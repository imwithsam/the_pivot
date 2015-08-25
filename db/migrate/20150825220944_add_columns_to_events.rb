class AddColumnsToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :user, index: true, foreign_key: true
    add_column :events, :venue, :text
    add_column :events, :event_date, :datetime
  end
end
