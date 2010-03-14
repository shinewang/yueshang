class Admin::CompaniesController < Admin::BaseController
  
  def initialize
    @current_tab = "公司管理"
  end

  def index
    @title = "公司列表"
    @companies = Company.find(:all, :order => sortable('created_at DESC'))
  end

  def destroy
    @company = Company.find(params[:company_id])
    @company.destroy
    flash[:notice] = '删除公司成功'
    redirect_to admin_list_company_path
  end

  def edit
    @title = "编辑公司"
    begin
      @company = Company.find(params[:company_id])
      @categories = Category.find(:all)
    rescue
      return render_not_found
    end
  end

  def update
    @title = "编辑公司"
    begin
      @company = Company.find(params[:company_id])
    rescue
      return render_not_found
    end
    if @company.update_attributes(params[:company])
      flash[:notice] = '用户信息修改已保存'
      #Audit.log(current_account, request.remote_ip, "用户", "更新", @company.record)
      redirect_to admin_list_company_path
    else
      render :action => "edit"
    end
  end

  def new
    @title = "新建公司"
    @company = Company.new
    @categories = Category.find(:all)
  end

  def create
    @company = Company.new(params[:company])
    if @company.save
      flash[:notice] = '公司新建成功'
      redirect_to admin_list_company_path
    else
      render :action => "new"
    end
  end

end
