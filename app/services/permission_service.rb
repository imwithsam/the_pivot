class PermissionService
  attr_reader :user, :controller, :action

  def initialize(user)
    @user = user
  end

  def allow?(controller, action)
    @controller = controller
    @action = action

    if user && user.platform_admin?
      platform_admin_permissions
    elsif user && user.store_admin?
      store_admin_permissions
    elsif user && user.registered_user?
      registered_user_permissions
    else
      guest_user_permissions
    end
  end

  private

  def platform_admin_permissions
    allowed = { "static_pages" => %w(index),
                "admin/events" => %w(index create new edit update),
                "admin/orders" => %w(index show update index_ordered index_paid index_cancelled index_completed),
                "admin/admins" => %w(index),
                "users" => %w(show update create new edit),
                "users/events" => %w(index show),
                "events" => %w(index show),
                "categories" => %w(show),
                "orders" => %w(index show),
                "cart_items" => %w(index create update destroy),
                "addresses" => %w(create new update),
                "sessions" => %w(new create destroy),
                "charges" => %w(create),
                "twilio" => %w(connect_customer) }
    check_permissions(allowed)
  end

  def store_admin_permissions
    allowed = { "static_pages" => %w(index),
                "admin/events" => %w(create new edit update),
                "users" => %w(show update create new edit),
                "users/events" => %w(index show),
                "events" => %w(index show),
                "categories" => %w(show),
                "orders" => %w(index show),
                "cart_items" => %w(index create update destroy),
                "addresses" => %w(create new update),
                "sessions" => %w(new create destroy),
                "charges" => %w(create),
                "twilio" => %w(connect_customer) }
    check_permissions(allowed)
  end

  def registered_user_permissions
    allowed = { "static_pages" => %w(index),
                "users" => %w(show update create new edit),
                "users/events" => %w(index show),
                "events" => %w(index show),
                "categories" => %w(show),
                "orders" => %w(index show),
                "cart_items" => %w(index create update destroy),
                "addresses" => %w(create new update),
                "sessions" => %w(new create destroy),
                "charges" => %w(create),
                "twilio" => %w(connect_customer) }
    check_permissions(allowed)
  end

  def guest_user_permissions
    allowed = { "static_pages" => %w(index),
                "users" => %w(show update create new edit),
                "users/events" => %w(index show),
                "events" => %w(index show),
                "categories" => %w(show),
                "addresses" => %w(create new update),
                "sessions" => %w(new create destroy) }
    check_permissions(allowed)
  end

  def check_permissions(allowed)
    return allowed[controller].include?(action) if allowed[controller]
  end
end
