Rails.application.routes.draw do
  devise_for :users
  # Defines the root path route ("/")
  root "invoices#index"
  get "/invoices", to: "invoices#index"

  get "/xero/connect", to: "invoices#connect"
  get "/xero/callback", to: "invoices#connect_callback"


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
