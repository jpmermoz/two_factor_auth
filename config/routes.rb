Rails.application.routes.draw do

  root  'pages#home'

  resources :users, 		only: [:new, :create, :show] 
  resources :sessions, 	only: [:new, :create, :destroy, :confirm, :validate]
  
  match '/signup',  	to: 'users#new', 	 				via: 'get'
  match '/signin',  	to: 'sessions#new',				via: 'get'
  match '/signout',		to: 'sessions#destroy', 	via: 'delete'
  match '/validate',	to: 'sessions#validate', 	via: 'post'
end
