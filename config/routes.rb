BacteriaGrowth::Application.routes.draw do

  devise_for :users , path_names: { sign_in: "login" , sign_out: "logout"}

  get "/404", :to => "errors#not_found"

  get "/delayed_job" => DelayedJobWeb, :anchor => false
  match "/documentation" , via: :get, controller: :home, action: "documentation", as: "documentation"

  resources :octave_models do
    get :estimator, on: :member
    post :estimator, on: :member
    get :solver, on: :member
    post :solver, on: :member
  end

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
      put :import
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
      get :history
      get :revert
    end
    resources :proxy_params
  end

  root :to => "home#index"
end
