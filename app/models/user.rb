class User < ActiveRecord::Base
  has_secure_password
  has_many :sales, class_name: "Order", inverse_of: :vendor, foreign_key: :vendor_id
  has_many :purchases, class_name: "Order", inverse_of: :customer, foreign_key: :customer_id
  has_many :addresses
  has_many :events
  has_many :user_roles
  has_many :roles, through: :user_roles
  before_validation :strip_whitespace, :generate_url
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true,
  format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :password, length: { minimum: 8 }

  def full_name
    "#{first_name} #{last_name}"
  end

  def registered_user?
    roles.exists?(name: "registered_user")
  end

  def store_admin?
    roles.exists?(name: "store_admin")
  end

  def platform_admin?
    roles.exists?(name: "platform_admin")
  end

  private

  def strip_whitespace
    self.first_name = first_name.strip if first_name
    self.last_name = last_name.strip if last_name
    self.email = email.strip if email
  end

  def generate_url
    self.url = username.parameterize
  end
end
