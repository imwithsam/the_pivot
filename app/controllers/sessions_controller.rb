class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])

    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success]   = "Welcome back to The Ocho Tickets, #{user.first_name}" \
        " #{user.last_name}!"
      redirect_to authenticated_user_paths(user)
    else
      flash[:warning] = "Unable to Login with this Email and" \
        " Password combination."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def authenticated_user_paths(user)
    if user.platform_admin?
      return admin_dashboard_path
    elsif can_make_purchases?(user) && has_events_in_cart?
      return dashboard_path
    else
      return cart_path
    end
  end

  def has_events_in_cart?
    cart.cart_items.empty?
  end

  def can_make_purchases?(user)
    user.registered_user? || user.store_admin?
  end
end
