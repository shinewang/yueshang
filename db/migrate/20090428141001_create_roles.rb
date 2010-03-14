class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "roles" do |t|
      t.column :name, :string
      t.timestamps
    end
    
    # generate the join table
    create_table "accounts_roles", :id => false do |t|
      t.column "role_id", :integer
      t.column "account_id", :integer
      t.timestamps
    end
    add_index "accounts_roles", "role_id"
    add_index "accounts_roles", "account_id"
  end

  def self.down
    drop_table "roles"
    drop_table "accounts_roles"
  end
end