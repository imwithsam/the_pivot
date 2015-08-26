class EventsController < ApplicationController
  def index
    @events = Event.active
  end

  def show
    load_featured_events
    @event = Event.find(params[:id])
  end
end
