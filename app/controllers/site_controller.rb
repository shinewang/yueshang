class SiteController < ApplicationController

  def index
    @title = APP_CONFIG['settings']['name']
    @current_tab = "首页"
  end

  def about
    @title = "关于我们"
  end

end
