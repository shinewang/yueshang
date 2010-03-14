class AccountMailer < ActionMailer::Base
  def signup_notification(account)
    setup_email(account)
    @subject    += '请激活你的帐号，完成注册!'
    @body[:url]  = "http://#{APP_CONFIG['settings']['domain']}/accounts/activate/#{account.activation_code}"
  
  end
  
  def activation(account)
    setup_email(account)
    @subject    += '你的帐号已激活!'
  end

  def forgot_password(account)
    setup_email(account)
    @subject    = "请重设在#{APP_CONFIG['settings']['name']}的密码"
    @body[:url] = "http://#{APP_CONFIG['settings']['domain']}/accounts/reset_password/#{account.password_reset_code}"
  end

  def reset_password(account)
    setup_email(account)
    @subject    += '密码重置成功!'
  end
  
  protected
    def setup_email(account)
      @recipients  = "#{account.email}"
      @from        = "#{APP_CONFIG['settings']['admin_mail']}"  #"#{APP_CONFIG['settings']['name']} <#{APP_CONFIG['settings']['admin_mail']}>"
      @subject     = "[#{APP_CONFIG['settings']['domain']}] "
      @sent_on     = Time.now
      @body[:account] = account
    end
end
