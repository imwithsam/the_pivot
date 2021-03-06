class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      assign_role
      new_account_notifications
      login_user

      flash[:success]   = "Welcome to The Ocho Tickets," \
        " #{@user.first_name} #{@user.last_name}!"
      redirect_to authenticated_user_paths(@user)
    else
      flash.now[:warning] = @user.errors.full_messages.join(". ")
      render :new
    end
  end

  def login_user
    session[:user_id] = @user.id
  end

  def show
    @events    = current_user.events
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
      update_to_vendor_account if user_changing_role?
      flash.now[:success] = "Your account has been updated."
    else
      flash.now[:warning] = @user.errors.full_messages.join(". ")
    end
    render :edit
  end

  private

  def user_changing_role?
    checkbox_checked = "1"
    user_params[:role] == checkbox_checked
  end

  def update_to_vendor_account
    current_role = @user.roles.first
    @user.roles.destroy(current_role)
    assign_role

    new_account_notifications
  end

  def user_params
    params.require(:user)
      .permit(:first_name, :last_name, :email, :password, :username, :role)
  end

  def logged_in_user
    unless current_user
      flash[:warning] = "That's a bold move Cotton. Please log in."
      redirect_to login_path
    end
  end

  def assign_role
    if params[:user][:role].eql?("1")
      @user.roles << Role.find_by(name: "store_admin")
    else
      @user.roles << Role.find_by(name: "registered_user")
    end
  end

  def new_account_notifications
    if @user.store_admin?
      NotificationsMailer.create_vendor_account(@user).deliver_later
    else
      NotificationsMailer.create_new_account(@user).deliver_later
    end
  end
end
