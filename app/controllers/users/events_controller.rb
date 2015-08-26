class Users::EventsController < ApplicationController

  def show

    current_user = User.find_by(url: params[:vendor]) if params[:vendor]
    @event = current_user.events.find_by(id: params[:id])
    @featured_events = current_user.events
  end
end
