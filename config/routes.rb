Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :user do 
    collection do 
      get 'login'
      post 'login'
      get 'signup'
      post 'signup'
      get 'logout'
    end
    member do
    end
  end
  
  root to: 'user#dashboard'
end
