Firstapp::Application.routes.draw do

  get "users/new"

	#http://guides.rubyonrails.org/routing.html	

	#resources :microposts
	#resources :users

	match '/signup', :to => 'users#new'

	match '/contact', :to => 'pages#contact'
	match '/about', :to => 'pages#about'
	match '/help', :to => 'pages#help'

  	root :to => 'pages#home'

  # See how all your routes lay out with "rake routes"
end
