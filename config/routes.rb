Rails.application.routes.draw do
  root 'bank_accounts#index'

  resources :bank_accounts, only: [:index] do
    collection do
      get :investment  
    end
  end
end
 
