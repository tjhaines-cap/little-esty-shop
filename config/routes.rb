Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/', to: 'application#welcome'
  
  get "/merchants/:merchant_id/dashboard", to: 'merchants#show'
end
