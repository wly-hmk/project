Rails.application.routes.draw do
  root 'user#index'

  # Endpoint to create a new user
  post '/user', to: 'user#create'

  # Endpoints for sites for current authenticated user
  get     '/sites',          to: 'sites#index'
  get     '/sites/:site_id', to: 'sites#show'
  post    '/sites',          to: 'sites#create'
  patch   '/sites/:site_id', to: 'sites#update'
  delete  '/sites/:site_id', to: 'sites#delete'

  # Endpoints for pages
  get     '/sites/:site_id/pages',            to: 'pages#index'
  post    '/sites/:site_id/pages',            to: 'pages#create'
  patch   '/sites/:site_id/pages/:page_id',   to: 'pages#update'
  delete  '/sites/:site_id/pages/:page_id',   to: 'pages#delete'

  # Endpoints for elements
  post    '/sites/:site_id/pages/:page_id/elements',              to: 'elements#create'
  patch   '/sites/:site_id/pages/:page_id/elements/:element_id',  to: 'elements#update'
  delete  '/sites/:site_id/pages/:page_id/elements/:element_id',  to: 'elements#delete'

  # Endpoint to generate a web page
  get '/website/:url', to: 'website#show', :constraints => { :url => /[^\/]+/ }

  # Non-existent routes
  match '*path', to: 'application#not_found', via: :all
end
