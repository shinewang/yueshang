class SetUpFirstAdminAccount < ActiveRecord::Migration
  def self.up
		#Be sure to change these settings for your initial admin user
    user = Account.new
		user.login = "admin"
		user.email = APP_CONFIG['settings']['admin_email']
		user.password = "password"
		user.password_confirmation = "password"
    user.activation_code = nil
    user.save(false)
		role = Role.new
		#Admin role name should be "admin" for convenience
		role.name = "admin"
		role.save
		admin_user = Account.find_by_login("admin")
		admin_role = Role.find_by_name("admin")
		admin_user.activated_at = Time.now.utc
    admin_user.activation_code = nil
		admin_user.roles << admin_role
		admin_user.save(false)		
  end

  def self.down
		admin_user = Account.find_by_login("admin")
		admin_user.roles = []
    admin_user.save
    admin_user.destroy
  end
end
