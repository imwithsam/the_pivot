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

    elsif @vendor.update(vendor_params)
      # update_to_vendor_account if vendor_params[:role] == "1"
      flash.now[:success] = "Your account has been updated."
    else
      flash.now[:warning] = @vendor.errors.full_messages.join(". ")
    end
    render :edit
  end

  def destroy
    @vendor = User.find(params[:id])
    @vendor.user_roles.first.update(role_id: Role.find_by(name: "registered_user").id)
    redirect_to admin_users_path
  end

  private

  def vendor_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :role)
  end
end
