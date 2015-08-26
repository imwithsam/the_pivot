class CartItem < SimpleDelegator
  attr_reader :quantity

  def initialize(event, quantity = 0)
    super(event)
    @quantity = quantity
  end

  def item_total
    quantity * price
  end
end
