DmsExt::Application.routes.draw do

  devise_for :users

  resources :calendar do
    member do
      get 'day'
    end
  end

  resources :upload do
    member do
      get 'state'
      post 'state'
    end
  end

  resources :people do
    resources :communications
  end

  resources :cars do
    resources :proposals
    resources :acts
    resources :dkps
  end

  resources :models
  resources :managers

  resources :communications do
    member do
      get 'short'
    end
  end

  resources :contracts
  resources :proposals
  resources :checkins
  resources :acts
  resources :dkps

  root :to => 'cars#index'

  match 'cars/:id/info' => 'cars#info'
end
