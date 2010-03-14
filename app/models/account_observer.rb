class AccountObserver < ActiveRecord::Observer
  def after_create(account)
    #AccountMailer.deliver_signup_notification(account)
  end

  def after_save(account)
  
    AccountMailer.deliver_activation(account) if account.recently_activated?
    AccountMailer.deliver_forgot_password(account) if account.recently_forgot_password?
    AccountMailer.deliver_reset_password(account) if account.recently_reset_password?
    AccountMailer.deliver_signup_notification(account) if (account.recently_created? || account.lost_activation?)
  end
end
