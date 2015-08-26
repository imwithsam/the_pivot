class Cart
  attr_reader :data

  def initialize(data = {})
    @data = data || Hash.new
  end

  def cart_items
    @data.map do |event_id, quantity|
      event = Event.find(event_id)
      CartItem.new(event, quantity)
    end
  end

  def items
    @data.map do |event_id, _quantity|
      Event.find(event_id)
    end
  end

  def add_item(event)
    data[event.id.to_s] ||= 0
    data[event.id.to_s] +=  1
  end

  def update_item_quantity(event, quantity)
    if quantity > 0
      data[event.id.to_s] = quantity
    else
      return false
    end
  end

  def delete_item(event)
    data.delete(event.id.to_s)
  end

  def total_price
    cart_items.reduce(0) do |total, cart_item|
      total + cart_item.item_total
    end
  end

  def clear
    @data = Hash.new
  end
end
