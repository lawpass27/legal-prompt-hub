Rails.application.routes.draw do
  devise_for :users
  
  authenticated :user do
    root "dashboard#index", as: :authenticated_root
  end
  
  root "legal_prompts#index"
  
  resources :legal_prompts
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions
  get "up" => "rails/health#show", as: :rails_health_check
end