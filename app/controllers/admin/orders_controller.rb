class Admin::OrdersController < Admin::BaseController
  before_action :find_all_orders, only: [:index, :index_ordered, :index_paid,
                                         :index_cancelled, :index_completed]
  before_action :find_single_order, only: [:show, :update]

  def index
    @status = :all
  end

  def index_ordered
    @status = :ordered
    render :index
  end

  def index_paid
    @status = :paid
    render :index
  end

  def index_cancelled
    @status = :cancelled
    render :index
  end

  def index_completed
    @status = :completed
    render :index
  end

  def show
    capability = Twilio::Util::Capability.new ENV["twilio_account_sid"], ENV["twilio_auth_token"]
    capability.allow_client_outgoing ENV["twilio_twiml_app_sid"]
    @token = capability.generate
  end

  def update
    @order.status = params[:status]
    @order.save
    redirect_to admin_orders_path
  end

  private

  def find_all_orders
    @orders = Order.all
  end

  def find_single_order
    @order = Order.find(params[:id])
  end
end
