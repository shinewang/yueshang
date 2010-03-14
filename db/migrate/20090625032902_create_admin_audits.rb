class CreateAdminAudits < ActiveRecord::Migration
  def self.up
    create_table :admin_audits do |t|
      t.column :account_id, :integer
      t.column :ip, :string
      t.column :module_name, :string
      t.column :action, :string
      t.column :record, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :admin_audits
  end
end
