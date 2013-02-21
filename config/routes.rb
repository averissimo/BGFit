BacteriaGrowth::Application.routes.draw do

  devise_for :users , path_names: { sign_in: "login" , sign_out: "logout"}

  match "/404", :to => "errors#not_found"

  match "/delayed_job" => DelayedJobWeb, :anchor => false
  match "/documentation" , via: :get, controller: :home, action: "documentation", as: "documentation"  
    
  resources :groups, path: :teams do
    resources :memberships, :only => [:new, :create, :destroy]
  end

  resources :dyna_models, path: :models do
    resources :params
    member do
      match "stats/experiment_detail" , :via => :get, :action => "experiment_detail", as: "experiment_detail_stats"
      get :stats
      get :export
      get :estimate
      put :calculate
      get :definition
      put :definition, action: "update"
      match "download/model" , via: :get, action: "definition" , as: "model"
      match "download/estimator" , via: :get, action: "estimator" , as: "estimator"
      match "download/simulator" , via: :get, action: "simulator" , as: "simulator"
    end
  end

  match "projects/public", via: :get, action: "public", controller: :models, as: "public_models"
  resources :models, path: :projects do
    member do
      get :new_measurement
    end
    resources :experiments
    resources :accessibles, :only => [:new, :create, :destroy]
  end

  resources :experiments, :except => [:new, :create] do
    resources :measurements
    resources :proxy_dyna_models, path: :proxy_models, :only => [:new, :create]
  end

  resources :measurements, :except => [:new, :create] do
      member do
        get :regression
        put :update_regression
        get :summary
      end   
      resources :lines
      #
      resources :proxy_dyna_models, path: :proxy_models
    end

  resources :proxy_dyna_models, path: :proxy_models, :except => [:new, :create] do
    member do
      put :calculate
    end
    resources :proxy_params
  end


  root :to => "home#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
