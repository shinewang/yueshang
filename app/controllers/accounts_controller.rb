class AccountsController < ApplicationController

  before_filter :login_required, :only => [:change_password]
  before_filter :sign_up_enable, :only => [:new, :create]

  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @account = Account.new(params[:account])
    @account.profile = Profile.new
    if disable_account_name(@account.login)
      @account.errors.add(:login, "输入的用户名不可用")
    else
      @account.save
    end
    if @account.errors.empty?
      #self.current_account = @account
      #redirect_back_or_default('/')
      #flash[:notice] = "注册确认信已经发往你的电子邮箱，请点击邮件中的链接来完成注册。"
    else
      render :action => 'new'
    end
  end

  def activate
    self.current_account = params[:activation_code].blank? ? false : Account.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_account.active?
      current_account.activate!
      flash[:notice] = "您的账户已激活!"
      redirect_back_or_default('/')
    else
      flash.now[:warning] = "激活码不正确!"
    end
  end

  def change_password
    return unless request.post?
    if Account.authenticate(current_account.login, params[:old_password])
      if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
        current_account.password_confirmation = params[:password_confirmation]
        current_account.password = params[:password]

        if current_account.save
          flash[:notice] = "密码修改成功!"
          redirect_to profile_path
        else
          flash.now[:warning] = "密码修改失败!"
        end

      else
        flash.now[:warning] = "两次输入的密码不相同。"
        @old_password = params[:old_password]
      end
    else
      flash.now[:warning] = "当前密码不正确，请重新输入。"
    end
  end

  def forgot_password
    return unless request.post?
    @account = Account.find_by_email(params[:account][:email])
    if @account && @account.active?
      @account.forgot_password
      @account.save
      flash.now[:status] = 'SENT'
      flash.now[:notice] = "请到#{params[:account][:email]}查阅来自#{APP_CONFIG['settings']['name']}的邮件，点击邮件中的链接重设你的密码。"
      #redirect_back_or_default('/')
    else
      flash.now[:warning] = "该邮箱地址尚未注册或者激活"
    end
  end

  def reset_password
    @account = Account.find_by_password_reset_code(params[:password_reset_code])
    if @account && !@account.password_reset_code_expire?
      if params[:account]
        if ((params[:account][:password] && params[:account][:password_confirmation]) && !params[:account][:password].blank? && !params[:account][:password_confirmation].blank? )
          if (params[:account][:password] == params[:account][:password_confirmation])
            self.current_account = @account #for the next two lines to work
            current_account.password_confirmation = params[:account][:password_confirmation]
            current_account.password = params[:account][:password]
            @account.reset_password
            flash[:notice] = current_account.save ? "密码重设成功。" : "密码重设失败。"
            redirect_back_or_default('/')
          else
            flash.now[:warning] = "两次输入的密码不相同。"
          end
        else
          flash.now[:warning] = "输入的密码不能为空。"
        end
      end
    else
      flash.now[:warning] = '密码重设验证码不正确或已失效'
      render :template => 'common/message' 
    end

  end

  def lost_activation
    if request.post?
      @account = Account.find_by_email(params[:account][:email])
      if @account!=nil && !@account.active?
        @account.lost_activation
        @account.save
      end
      render :template => 'accounts/create'
    end
  end

  private
    def sign_up_enable
       if APP_CONFIG['settings']['sign_up_enable'] == 'disable'
         render :template => 'accounts/sign_up_disable'
       end
    end

    def disable_account_name(account_name)
      disable_account_name = APP_CONFIG['settings']['disable_account_name']
      pos = disable_account_name.index(account_name)
      pos && (pos == 0 || pos > 0 && disable_account_name[pos-1].chr == ',') &&
        (pos + account_name.length == disable_account_name.length ||
          pos + account_name.length < disable_account_name.length && disable_account_name[pos + account_name.length].chr == ',')
    end

end
