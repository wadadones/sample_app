Rails.application.routes.draw do
  get '/signup', to: 'users#new'

  get '/help', to: 'static_pages#help'
  #getリクエストが/helpに送られたとき、StaticPageコントローラのhelpアクションが呼ばれる
  #help_path -> '/help'
  #help_url -> 'http://www.example.com/help'が利用可能になる
	get '/about', to: 'static_pages#about'
	get '/contact', to: 'static_pages#contact'
  root 'static_pages#home'
  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
