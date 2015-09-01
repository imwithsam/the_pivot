class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      assign_role

      NotificationsMailer.contact(
        @user.email,
        "Welcome to Ocho Tickets!",
        "Your new account has been created, giving you access to" \
          " exclusive events including the Total Ghost concert, the Bubble" \
          " Soccer Quarterfinals, and the Nathan's Hotdog Eating Qualifiers!" \
          " \n" \
          " Bookmark http://ochotickets.herokuapp.com/ and log in with" \
          " your email address (#{@user.email}) and your password."
      ).deliver_later

      session[:user_id] = @user.id
      flash[:success]   = "Welcome to The Ocho Tickets," \
        " #{@user.first_name} #{@user.last_name}!"
      redirect_to dashboard_path
    else
      flash.now[:warning] = @user.errors.full_messages.join(". ")
      render :new
    end
  end

  def assign_role
    if params[:user][:role].eql?("1")
      @user.roles << Role.find_by(name: "store_admin")
    else
      @user.roles << Role.find_by(name: "registered_user")
    end
  end

  def show
    @events = current_user.events
    @my_orders = Order.where(customer_id: current_user.id)
  end

  def index
    @users = User.all.select { |user| user.store_admin? && user.events.exists? }
  end

  def edit
    @user     = current_user
    @billing  = @user.addresses.billing.last
    @shipping = @user.addresses.shipping.last
  end

  def update
    @user     = current_user
    @billing  = @user.addresses.billing.last
    @shipping = @user.addresses.shipping.last

    if !@user.authenticate(params[:user][:password])
      flash.now[:warning] =
        "Invalid password. Please re-enter to update your login info."
    elsif @user.update(user_params)
      flash.now[:success] = "Your account has been updated."
    else
      flash.now[:warning] = @user.errors.full_messages.join(". ")
    end
    render :edit
  end

  private

  def user_params
    params.require(:user)
      .permit(:first_name, :last_name, :email, :password, :username, :role)
  end

  def logged_in_user
    unless current_user
      flash[:warning] = "Please log in."
      redirect_to login_path
    end
  end
end
