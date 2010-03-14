class  Admin::BaseController < ApplicationController
  layout 'admin'
  before_filter :login_required
	require_role :admin
end
