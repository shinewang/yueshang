class ForgetPsssword < ActiveRecord::Migration
  def self.up
    add_column :accounts, :password_reset_code, :string
    add_column :accounts, :password_reset_code_until, :datetime
  end

  def self.down
    remove_column :accounts, :password_reset_code
    remove_column :accounts, :password_reset_code_until
  end
end
