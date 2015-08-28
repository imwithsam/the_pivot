class Admin::EventsController < Admin::BaseController
  before_action :set_event, only: [:edit, :update]

  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.new(event_params)

    if @event.save
      flash[:success] = "#{@event.name} has been added."
      redirect_to admin_dashboard_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @event.update(event_params)
    flash[:success] = "#{@event.name} has been updated."
    redirect_to admin_events_path
  end

  private

  def event_params
    params.require(:event).permit(:name,
                                  :description,
                                  :price,
                                  :image_url,
                                  :category_id,
                                  :status,
                                  :user_id,
                                  :venue,
                                  :event_date)
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
