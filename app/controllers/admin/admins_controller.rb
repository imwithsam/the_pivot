class Admin::AdminsController < Admin::BaseController
  def index
    @event = Event.new
  end
end
