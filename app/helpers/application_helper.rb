module ApplicationHelper
  def is_registered_user?
    current_user && current_user.registered_user?
  end

  def is_store_admin?
    current_user && current_user.store_admin?
  end

  def is_platform_admin?
    current_user && current_user.platform_admin?
  end
end
