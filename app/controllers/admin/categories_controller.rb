# To change this template, choose Tools | Templates
# and open the template in the editor.

class Admin::CategoriesController < Admin::BaseController

  def initialize
    @current_tab = "分类管理"
  end

  def index
    @title = "分类列表"
    @categories = Category.find(:all, :order => sortable('created_at DESC'))
  end

  def new
    if (params[:parent_id] == '0')
      @parent_category = nil
    else
      @parent_category = Category.find(params[:parent_id])
    end
    @category = Category.new
  end
  
  def create
    @category = Category.new(params[:category])
    @category.parent_category_id = params[:parent_id]
    if @category.save
      flash[:notice] = '小组创建成功'
      redirect_to admin_list_category_path
    else
      render :action => "new"
    end
  end

end