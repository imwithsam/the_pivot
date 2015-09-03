class Admin::UsersController < Admin::BaseController
  def index
    @vendors = User.all.select{|user| user.store_admin? }
  end

  def edit
    @vendor     = User.find(params[:id])
    @billing  = @vendor.addresses.billing.last
    @shipping = @vendor.addresses.shipping.last
  end

  def update
    @vendor     = User.find(params[:id])
    @billing  = @vendor.addresses.billing.last
    @shipping = @vendor.addresses.shipping.last

    if !@vendor.authenticate(params[:user][:password])
      flash.now[:warning] =
        "Invalid password. Please re-enter to update your login info."
        redirect_to edit_admin_path(vendor.id)
    elsif @vendor.update(vendor_params)
      update_to_vendor_account if vendor_params[:role] == "1"
      flash.now[:success] = "Your account has been updated."
    else
      flash.now[:warning] = @vendor.errors.full_messages.join(". ")
    end
    redirect_to edit_admin_path(@vendor)
  end

  private

  def update_to_vendor_account
    current_role = @vendor.roles.first
    @vendor.roles.destroy(current_role)
    assign_role

    new_account_notifications
  end

  def new_account_notifications
    if @vendor.store_admin?
      NotificationsMailer.create_vendor_account(@vendor).deliver_later
    else
      NotificationsMailer.create_new_account(@vendor).deliver_later
    end
  end

  def assign_role
    if params[:user][:role].eql?("1")
      @vendor.roles << Role.find_by(name: "store_admin")
    else
      @vendor.roles << Role.find_by(name: "registered_user")
    end
  end

  def vendor_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :role)
  end
end
