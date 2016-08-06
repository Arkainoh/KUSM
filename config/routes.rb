Rails.application.routes.draw do
 
  devise_for :users
  
  get 'home/index'
  get 'home/updateDB/:timeInfo' => 'home#updateDB'
  # :timeInfo looks like 2016_8 (year:2016 month:8)
  get 'home/calendar' #달력
  get 'home/showDB'
  get 'home/viewfilter'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  get '/search_result' => 'home#search_result'
  get '/post_view/:postid' => 'home#post_view'
  get '/' => 'home#index'
  get 'home/main_page'
  get 'home/template_index'
  get 'home/mypage'
  get 'home/updateDB' => 'home#updateDB'
  get 'home/board_view'
  get 'home/board_write'
  post 'home/comment_write' => 'home#comment_write'
  
  post '/write' => 'home#write'
  get 'destroy/:post_id' => "home#destroy"
  get 'update_view/:post_id' => "home#update_view"
  post 'update/:post_id' => "home#update"
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
