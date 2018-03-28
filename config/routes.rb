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
    collection do
      get 'search'
      get 'perform_search'
    end
  end
end
