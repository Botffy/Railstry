Firstapp::Application.routes.draw do
	#static pages
  	get "pages/home"
  	get "pages/contact"
  	get "pages/about"

  resources :microposts
  resources :users

	#http://guides.rubyonrails.org/routing.html	

  root :to => 'pages#home'

  # See how all your routes lay out with "rake routes"
end
