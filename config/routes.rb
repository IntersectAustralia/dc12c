Dc12c::Application.routes.draw do
  resources :access_requests, only: [:index, :show] do
    member do
      put :approve
      put :reject
      put :revoke
    end
    collection do
      get :pending
      get :approved
      get :rejected
    end
  end

  resources :papyri, only: [:new, :create, :show, :edit, :update, :index] do
    collection do
      get :search
      get :advanced_search
    end
    member do
      post :request_access
      post :cancel_access_request
      post :make_hidden
      post :make_visible
      post :make_public
    end

    resources :images, only: [:new, :create, :edit, :update, :destroy]
    resources :names, only: [:new, :create, :edit, :update, :destroy]
    resources :connections, only: [:new, :create, :edit, :update, :destroy]
  end

  resources :collections, only: [:index, :show, :new, :create, :edit, :update]

  match 'papyrus/:papyrus_id/image/:id/thumbnail' => 'Images#thumbnail'
  match 'papyrus/:papyrus_id/image/:id/low_res' => 'Images#low_res'
  match 'papyrus/:papyrus_id/image/:id/original' => 'Images#high_res'
  match 'admin/index' => 'Admin#index'
  resources :trismegistos, only: [] do
    collection do
      get :download
    end
  end
  resources :papyriinfo, only: [] do
    collection do
      get :download_zip
    end
  end

  match 'users/sign_up' => "Pages#not_found" # render default 404 and override's devise's routes as it comes first
  devise_for :users, controllers: {registrations: "user_registers", passwords: "user_passwords"}
  devise_scope :user do
    get "/users/profile", :to => "user_registers#profile" #page which gives options to edit details or change password
    get "/users/edit_password", :to => "user_registers#edit_password" #allow users to edit their own password
    put "/users/update_password", :to => "user_registers#update_password" #allow users to edit their own password
  end

  resources :users, :only => [:show] do

    collection do
      get :index
      get :new_one_id
      post :create_one_id
    end

    member do
      put :reject
      put :reject_as_spam
      put :deactivate
      put :activate
      get :edit_role
      put :update_role
      get :edit_approval
      put :approve

    end
  end

  root :to => "pages#home"

  get "pages/home"

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
  # match ':controller(/:action(/:id))(.:format)'
end
