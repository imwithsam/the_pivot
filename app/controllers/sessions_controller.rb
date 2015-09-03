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
      flash[:warning] = "That's a bold move Cotton. But You're unable to Login with this Email and" \
        " Password combination."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private
end
