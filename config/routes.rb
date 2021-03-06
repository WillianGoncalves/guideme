Rails.application.routes.draw do
  devise_for :users
  #devise_scope :users do
    #resources :contracts, only: [:index]
  #end

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
    resources :contracts, only: [:new, :create]
  end

  resources :contracts, only: [:index, :show, :update] do
    member do
      post 'reject'
      post 'cancel'
      post 'finish'
    end
    resources :payments, only: [:new, :create]
  end
end
