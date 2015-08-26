class EventsController < ApplicationController
  def index
    @events = Event.active
  end

  def show
    load_featured_products
    @event = Event.find(params[:id])
  end
end
