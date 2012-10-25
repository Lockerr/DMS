DmsExt::Application.routes.draw do

  resources :opts

  match 'manage' => 'manage#index'
  
  resources :interiors
  resources :colors

  devise_for :users

  resource :trade_ins

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
    resource :contract
    resource :act
    resource :dkp
    resource :ckp
    resource :proposal
  end

  resources :models
  resources :managers

  resources :communications do
    member do
      get 'short'
    end
  end

  resources :contracts, :belongs_to => :car
  resources :proposals
  resources :checkins
  resources :acts
  resources :dkps

  root :to => 'cars#index'

  match 'cars/:id/info' => 'cars#info'
  match 'makedoc' => 'contracts#index'

end
