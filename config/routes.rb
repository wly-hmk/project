Rails.application.routes.draw do
  root 'user#index'

  # Endpoint to create a new user
  post '/user', to: 'user#create'

  # Endpoints for sites for current authenticated user
  get   '/sites',          to: 'sites#index'
  post  '/sites',          to: 'sites#create'
  patch '/sites/:site_id', to: 'sites#update'

  # Endpoints for pages
  get   '/sites/:site_id',   to: 'pages#index'
  post  '/sites/:site_id',   to: 'pages#create'
  patch '/pages/:page_id',   to: 'pages#update'

  # Endpoints for elements
  post  '/pages/:page_id',       to: 'elements#create'
  patch '/elements/:element_id', to: 'elements#update'

  # Endpoint to generate a web page
  get '/website/:url',      to: 'WebsiteController#show'
end
