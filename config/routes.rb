Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search

  # Authentication routes
  resources :sessions
  resources :users
  get 'users/new', to: 'users#new', as: :signup
  get 'user/edit', to: 'users#edit', as: :edit_current_user
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  # Routes for main resources
  resources :camps
  resources :instructors
  resources :families
  resources :students
  resources :locations
  resources :curriculums
  resources :registrations
  resources :carts
  

  # Routes for managing camp instructors
  
  get 'camps/:id/instructors', to: 'camps#instructors', as: :camp_instructors
  post 'camps/:id/instructors', to: 'camp_instructors#create', as: :create_instructor
  delete 'camps/:id/instructors/:instructor_id', to: 'camp_instructors#destroy', as: :remove_instructor

  get 'add_to_cart', to: 'carts#add_to_cart', as: :add_to_cart
  #get 'cart/:camp_id/:student_id', to: 'cart#removeFromCart', as: :remove_from_cart
  #get 'carts/show', to: 'carts#show', as: :show_cart

  # You can have the root of your site routed with 'root'
  root 'home#index'
end