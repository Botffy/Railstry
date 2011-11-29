Firstapp::Application.routes.draw do

  get "sessions/new"


	#http://guides.rubyonrails.org/routing.html	

	resources :users
	resources :sessions, :only=>[:new, :create, :destroy]

	match '/signup', :to => 'users#new'

	match '/signin', :to=> 'sessions#new'
	match '/signout', :to=> 'sessions#destroy'

	match '/contact', :to => 'pages#contact'
	match '/about', :to => 'pages#about'
	match '/help', :to => 'pages#help'

  	root :to => 'pages#home'

  # See how all your routes lay out with "rake routes"
end
