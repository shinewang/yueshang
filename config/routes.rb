ActionController::Routing::Routes.draw do |map|
  map.resources :categories

  map.resources :companies


  #map.resources :accounts
  #map.resource :session

  map.activate '/accounts/activate/:activation_code', :controller => 'accounts', :action => 'activate'
  map.forgot_password '/accounts/forgot_password', :controller => 'accounts', :action => 'forgot_password'
  map.reset_password '/accounts/reset_password/:password_reset_code', :controller => 'accounts', :action => 'reset_password'
  map.change_password '/accounts/change_password', :controller => 'accounts', :action => 'change_password'
  map.lost_activation '/accounts/lost_activation', :controller => 'accounts', :action => 'lost_activation'
  map.new_account '/accounts/new', :controller => 'accounts', :action => 'new', :conditions => {:method => :get}
  map.create_account '/accounts/new', :controller => 'accounts', :action => 'create', :conditions => {:method => :post}

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.home '', :controller => 'site', :action => 'index'
  map.mine '/mine', :controller => 'site', :action => 'mine'
  map.about '/about', :controller => 'site', :action => 'about'
  map.login  '/login', :controller => 'sessions', :action => 'new', :conditions => {:method => :get}
  map.login  '/login', :controller => 'sessions', :action => 'create', :conditions => {:method => :post}
  map.logout '/logout', :controller => 'sessions', :action => 'destroy', :conditions => {:method => :delete}

  map.namespace :admin do |admin|
    admin.index '', :controller => 'audit', :action => 'index', :conditions => {:method => :get}
    admin.list_audit 'audit', :controller => 'audit', :action => 'index', :conditions => {:method => :get}
    admin.list_failure 'failure', :controller => 'log', :action => 'index', :conditions => {:method => :get}
    admin.destroy_failure 'failure/:id', :controller => 'log', :action => 'destroy', :conditions => {:method => :delete}
    admin.list_account 'account', :controller => 'accounts', :action => 'index', :conditions => {:method => :get}
    admin.activate_account 'account/:id', :controller => 'accounts', :action => 'activate', :conditions => {:method => :put}
    admin.edit_account 'account/:id/edit', :controller => 'accounts', :action => 'edit', :conditions => {:method => :get}
    admin.update_account 'account/:id/edit', :controller => 'accounts', :action => 'update', :conditions => {:method => :put}
    admin.edit_account_role 'account/:id/edit_role', :controller => 'accounts', :action => 'edit_role', :conditions => {:method => :get}
    admin.add_account_role 'account/:id/add_role', :controller => 'accounts', :action => 'add_role', :conditions => {:method => :post}
    admin.remove_account_role 'account/:id/remove_role/:role', :controller => 'accounts', :action => 'remove_role', :conditions => {:method => :delete}
    admin.list_category 'category', :controller => 'categories', :action => 'index', :conditions => {:method => :get}
    admin.new_category 'category/:parent_id/new', :controller => 'categories', :action => 'new', :conditions => {:method => :get}
    admin.create_category 'category/:parent_id/new', :controller => 'categories', :action => 'create', :conditions => {:method => :post}
    admin.list_company 'company', :controller => 'companies', :action => 'index', :conditions => {:method => :get}
    admin.new_company 'company/new', :controller => 'companies', :action => 'new', :conditions => {:method => :get}
    admin.create_company 'company/new', :controller => 'companies', :action => 'create', :conditions => {:method => :post}
    admin.edit_company 'company/:company_id/edit', :controller => 'companies', :action => 'edit', :conditions => {:method => :get}
    admin.update_company 'company/:company_id/edit', :controller => 'companies', :action => 'edit', :conditions => {:method => :put}
    admin.destroy_company 'company/:company_id', :controller => 'companies', :action => 'destroy', :conditions => {:method => :delete}
  end

  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'

end
