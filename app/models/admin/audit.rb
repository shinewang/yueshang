class Admin::Audit < ActiveRecord::Base
  set_table_name "admin_audits"
  belongs_to :account
  
  def self.log(account, ip, module_name, action, record)
    audit = new(:account_id => account.id,
                :ip => ip,
                :module_name => module_name,
                :action => action,
                :record => record)
    audit.save
  end
end
