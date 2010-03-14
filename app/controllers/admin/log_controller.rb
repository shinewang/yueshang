class Admin::LogController < Admin::BaseController

  def initialize
    @current_tab = "日志"
  end

  def index
    @title = "登录失败记录"
    @failures = UserFailure.paginate :page => params[:page], :per_page => 2, :order => sortable('updated_at DESC')
  end

  def destroy
    begin
      @user_failure = UserFailure.find(params[:id])
    rescue
      return render_not_found
    end
    @user_failure.destroy
    Audit.log(current_account, request.remote_ip, "登录失败记录", "删除", @user_failure.record)
    redirect_to admin_list_failure_path
  end
end
