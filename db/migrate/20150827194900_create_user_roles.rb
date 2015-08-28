class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.references :role, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
    end
  end
end
