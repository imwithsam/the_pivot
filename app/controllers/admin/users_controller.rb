class Admin::UsersController < Admin::BaseController
  before_action :find_single_vendor, only: [:edit, :update, :destroy]
  before_action :find_addresses, only: [:edit, :update]

  def index
    @vendors = User.all.select{|user| user.store_admin? }
  end

  def new
    @vendor = User.new
  end

  def create
    @vendor = User.new(vendor_params)

    if @vendor.save
      assign_role
      new_account_notifications

      flash[:success]   = "Welcome to The Ocho Tickets," \
        " #{@vendor.first_name} #{@vendor.last_name}!"
      redirect_to admin_users_path
    else
      flash.now[:warning] = @vendor.errors.full_messages.join(". ")
      render :new
    end
  end

  def edit
  end

  def update
    if !@vendor.authenticate(params[:user][:password])
      flash.now[:warning] =
        "Invalid password. Please re-enter to update your login info."

    elsif @vendor.update(vendor_params)
      # update_to_vendor_account if vendor_params[:role] == "1"
      flash.now[:success] = "Your account has been updated."
    else
      flash.now[:warning] = @vendor.errors.full_messages.join(". ")
    end
    render :edit
  end

  def destroy
    @vendor.user_roles.first.update(role_id: Role.find_by(name: "registered_user").id)
    redirect_to admin_users_path
  end

  private

  def vendor_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :role)
  end

  def find_single_vendor
    @vendor = User.find(params[:id])
  end

  def find_addresses
    @billing  = @vendor.addresses.billing.last
    @shipping = @vendor.addresses.shipping.last
  end

  def assign_role
    if params[:user][:role].eql?("1")
      @vendor.roles << Role.find_by(name: "store_admin")
    else
      @vendor.roles << Role.find_by(name: "registered_user")
    end
  end

  def new_account_notifications
    if @vendor.store_admin?
      NotificationsMailer.create_vendor_account(@vendor).deliver_later
    else
      NotificationsMailer.create_new_account(@vendor).deliver_later
    end
  end
end
