Rails.application.routes.draw do
  resources :games, only: [:index, :create, :show, :edit, :update]  
end
