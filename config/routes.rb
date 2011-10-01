Firstapp::Application.routes.draw do
	#http://guides.rubyonrails.org/routing.html	

	resources :microposts
	resources :users

	match '/contact', :to => 'pages#contact'
	match '/about', :to => 'pages#about'

  	root :to => 'pages#home'

  # See how all your routes lay out with "rake routes"
end
