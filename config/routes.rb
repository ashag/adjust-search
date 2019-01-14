Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'homepage#main'

  get '/search_results', to: 'homepage#search_results'
end
