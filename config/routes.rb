Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  resources :users, only: [] do
    resources :guides, except: [:index]
  end
  resources :guides, only: [:index, :show] do
    member do
      put 'update_status'
    end
  end
end
