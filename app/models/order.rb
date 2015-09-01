class Order < ActiveRecord::Base
  belongs_to :user
  has_many :event_orders
  has_many :events, through: :event_orders
  # belongs_to :vendor, class_name: "User"
  enum status: ["ordered", "paid", "cancelled", "completed"]
  validates :status,
    inclusion: { in: ["ordered", "paid", "cancelled", "completed"] }

  scope :ordered,   -> { where(status: 0) }
  scope :paid,      -> { where(status: 1) }
  scope :cancelled, -> { where(status: 2) }
  scope :completed, -> { where(status: 3) }

  def total
    event_orders.reduce(0) do |total, order_item|
      total + (order_item.quantity * order_item.unit_price)
    end
  end

  def available_status_transitions
    case status
    when "paid"
      ["cancelled", "completed"]
    when "ordered"
      ["cancelled", "paid"]
    else
      []
    end
  end
end
