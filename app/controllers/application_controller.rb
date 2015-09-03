class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize!

  add_flash_types :success, :info, :warning, :danger

  def load_featured_events
    @featured_events = Event.limit(6).order("RANDOM()")
  end

  def cart
    @cart ||= Cart.new(session[:cart])
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_permission
    @current_permission ||= PermissionService.new(current_user)
  end

  def authorize!
    redirect_to root_url,
      warning: "Bold move Cotton but you are an unauthorized boat owner!!" unless authorized?
  end

  def authorized?
    current_permission.allow?(params[:controller], params[:action])
  end

  def validate_store_admin
    current_user && current_user.url == params[:vendor] if params[:vendor]
  end

  def authenticated_user_paths(user)
    if user.platform_admin?
      return admin_dashboard_path
    elsif can_make_purchases?(user) && has_events_in_cart?
      return cart_path
    else
      return dashboard_path
    end
  end

  def has_events_in_cart?
    !cart.cart_items.empty?
  end

  def can_make_purchases?(user)
    user.registered_user? || user.store_admin?
  end

  helper_method :current_user, :cart, :validate_store_admin
end
