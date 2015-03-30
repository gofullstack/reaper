Rails.application.routes.draw do
  root to: 'pages#index'

  get '/auth/:provider/callback' => "sessions#create"

  get 'invoices' => 'pages#invoices'
  post 'login' => 'pages#login'
  post 'logout' => 'pages#logout'
  post 'export' => 'pages#export'

  get 'tos' => 'pages#tos'
  get 'privacy' => 'pages#privacy'
end
