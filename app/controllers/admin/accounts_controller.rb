class Admin::AccountsController < Admin::BaseController

  def initialize
    @current_tab = "用户管理"
  end

  def index
    @title = "用户列表"
    @accounts = Account.paginate :page => params[:page], :per_page => 2, :order => sortable('created_at DESC')
  end

  def show
    @title = "查看用户"
    begin
      @account = Account.find(params[:id])
    rescue
      return render_not_found
    end
  end

  def edit
    @title = "修改用户"
    begin
      @account = Account.find(params[:id])
    rescue
      return render_not_found
    end
  end

  def update
    @title = "修改用户"
    begin
      @account = Account.find(params[:id])
    rescue
      return render_not_found
    end
    if @account.update_attributes(params[:account])
      flash[:notice] = '用户信息修改已保存'
      Audit.log(current_account, request.remote_ip, "用户", "更新", @account.record)
      redirect_to admin_list_account_path
    else
      render :action => "edit"
    end
  end

  def edit_role
    @title = "修改用户权限角色"
    begin
      @account = Account.find(params[:id])
      @roles = Role.find :all
      @roles -= @account.roles
    rescue
      return render_not_found
    end
  end

  def add_role
    begin
      @account = Account.find(params[:id])
      @role = Role.find(params[:role][:id])
    rescue
      return render_not_found
    end
    if @account.roles.include?(@role)
      flash[:warning] = '用户已包含该权限角色'
    else
      @account.roles << @role
      flash[:notice] = '用户权限角色添加成功'
    end
    Audit.log(current_account, request.remote_ip, "用户", "添加权限角色", @account.record + ": #{@role.name}")
    redirect_to admin_edit_account_role_path(@account)
  end
  
  def remove_role
    begin
      @account = Account.find(params[:id])
      @role = Role.find(params[:role])
      @account.roles.delete(@role)
    rescue
      return render_not_found
    end
    flash[:notice] = '用户权限角色删除成功'
    Audit.log(current_account, request.remote_ip, "用户", "删除权限角色", @account.record + ": #{@role.name}")
    redirect_to admin_edit_account_role_path(@account)
  end

  def activate
    begin
      @account = Account.find(params[:id])
    rescue
      return render_not_found
    end
    @account.activate
    Admin::Audit.log(current_account, request.remote_ip, "用户", "激活", @account.record)
    redirect_to admin_list_account_path
  end
end
