# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include AuthenticatedSystem
  # You can move this into a different controller, if you wish.  This module gives you the require_role helpers, and others.
  include RoleRequirementSystem
  include ExceptionNotifiable

  before_filter :check_open_status

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'ed1d379be87f2b82b2b14c422aed0ab9'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  # Return true if a parameter corresponding to the given symbol was posted.
  def param_posted?(symbol)
    request.post? and params[symbol]
  end

  #重写Rails方法，production环境下全局处理errors
#  def rescue_action_in_public(exception)
#    case exception.class.name
#    when 'ActiveRecord::RecordNotFound','ActionController::UnknownAction','ActionController::RoutingError'
#         RAILS_DEFAULT_LOGGER.error("404 displayed")
#         render(:file => "#{RAILS_ROOT}/public/404.html", :status => "404 Error")
#    when 'ActionController::InvalidAuthenticityToken','ActionController::MethodNotAllowed'
#       RAILS_DEFAULT_LOGGER.error("401 displayed")
#       render(:file => "#{RAILS_ROOT}/public/401.html", :status => "401 Error")
#    else
#       RAILS_DEFAULT_LOGGER.error("500 displayed")
#       render(:file => "#{RAILS_ROOT}/public/500.html", :status => "500 Error")
#    end
#  end

  #重写Rails方法，development环境下全局处理errors
#  def rescue_action_locally(exception)
#    case exception.class.name
#    when 'ActiveRecord::RecordNotFound','ActionController::UnknownAction','ActionController::RoutingError'
#        RAILS_DEFAULT_LOGGER.error("404 displayed")
#        render(:file => "#{RAILS_ROOT}/public/404.html", :status => "404 Error")
#    when 'ActionController::InvalidAuthenticityToken','ActionController::MethodNotAllowed'
#       RAILS_DEFAULT_LOGGER.error("401 displayed")
#       render(:file => "#{RAILS_ROOT}/public/401.html", :status => "401 Error")
#    else
#       RAILS_DEFAULT_LOGGER.error("500 displayed")
#       render(:file => "#{RAILS_ROOT}/public/500.html", :status => "500 Error")
#    end
#  end

  def check_open_status
    if APP_CONFIG['settings']['open_status'] == 'close'
      render :template => 'common/site_closed'
    end
  end

  def render_not_found
    @title = "页面不存在"
    render :template => "common/not_found"
  end

  def render_access_denied
    @title = "没有访问权限"
    render :layout => 'application', :template => "common/access_denied"
  end

  def offset(page, page_size)
    page && page.to_i ? (page.to_i-1)*page_size : 0
  end

  def sortable(default)
    if params[:sort]
      "#{params[:sort]} asc"
    elsif params[:sort_desc]
      "#{params[:sort_desc]} desc"
    else
      default
    end
  end
  
end
