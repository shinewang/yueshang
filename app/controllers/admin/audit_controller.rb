class Admin::AuditController < Admin::BaseController

  def initialize
    @current_tab = "日志"
  end

  def index
    @title = "后台操作记录"
    @audits = Audit.paginate :page => params[:page], :per_page => 2, :order => sortable('created_at DESC')
  end
end
