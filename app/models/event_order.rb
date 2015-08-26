class EventOrder < ActiveRecord::Base
  belongs_to :order
  belongs_to :event
  validates :quantity, numericality: { greater_than: 0 }

  def subtotal
    unit_price * quantity
  end
end
