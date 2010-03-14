# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  # render new.rhtml
  def new
    #	Display recaptcha only if the number of failed logins have
		# exceeded the specified limit within a certain timeframe
    @title = "登录"
		@bad_visitor = UserFailure.failure_check(request.remote_ip)
		respond_to do |format|
      format.html
			format.js
    end
  end

  def create
    # Only verify recaptcha if the user has reached the failed login limit
    @title = "登录"
		@bad_visitor = UserFailure.failure_check(request.remote_ip)
    if @bad_visitor && !verify_recaptcha
      UserFailure.record_failure(request.remote_ip, request.env['HTTP_USER_AGENT'], "login", params[:login])
      flash.now[:notice] = "认证码不正确"
      render :action => 'new'
      return
    end
    self.current_account = Account.authenticate(params[:login], params[:password])

    if logged_in?
      if current_account.enable
        if params[:remember_me] == "1"
          current_account.remember_me unless current_account.remember_token?
          cookies[:auth_token] = { :value => self.current_account.remember_token , :expires => self.current_account.remember_token_expires_at }
        end
        logger.info("登录成功:#{params[:login]}@#{Time.now.to_s} #{request.remote_ip}")
        redirect_back_or_default('/')
      else
        self.current_account = nil;
        logger.info("登录失效:#{params[:login]}@#{Time.now.to_s} #{request.remote_ip}")
        flash.now[:notice] = "该账号目前处于失效状态"
        render :action => 'new'
      end
    else
      UserFailure.record_failure(request.remote_ip, request.env['HTTP_USER_AGENT'], "login", params[:login])
      flash.now[:notice] = "用户名或密码不正确或者该用户尚未激活"
      render :action => 'new'
    end
  end

  def destroy
    self.current_account.forget_me if logged_in?
    cookies.delete :auth_token
    self.current_account = nil
    reset_session
    #flash[:notice] = "#{APP_CONFIG['settings']['name']}随时欢迎你回来。"
  end
end
