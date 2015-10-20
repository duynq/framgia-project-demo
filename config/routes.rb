Rails.application.routes.draw do

  get 'comments/create'

  get 'comments/destroy'

  get 'password_resets/new'
  get 'password_resets/edit'

  root 'static_pages#home'
  # root 'learns#pdf'

  get     'home'    => 'static_pages#home'
  get     'help'    => 'static_pages#help'
  get     'about'   => 'static_pages#about'
  get     'contact' =>  'static_pages#contact'

  get     'signup'  => 'users#new'
  get     'login'   => 'static_pages#home'
  post    'login'   => 'sessions#create'
  delete  'logout'  => 'sessions#destroy'

  resources :users do
    # get 'name', on: :member

    # goi theo ca id
    member do
      get :following, :followers
    end

    # goi ko can id
    # collection do
    #   get :xx, :yy
    # end

  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :entries  #, only: [:create, :destroy, :edit, :update, :show]
  resources :relationships, only: [:create, :destroy]
  resources :comments

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
