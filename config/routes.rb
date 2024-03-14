# rubocop:disable all
Rails.application.routes.draw do
  require 'sidekiq/web'

  devise_for :admins, skip: :registrations

  scope module: 'admins' do
    get 'admins/:model/dashboard/', to: 'dashboard#index', as: 'dashboard'
    get 'admins/:model/dashboard/:record', to: 'dashboard#show', as: 'dashboard_record'
    delete 'admins/:model/dashboard/:record', to: 'dashboard#destroy', constraints: { model: /(users|pages)/  }
  end

  devise_scope :admin do
    authenticated :admin do
      root to:  'admins/dashboard#index', as: :authenticated_admin_root
    end
  end

  resource :invitee, only: [:create]

  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end

  scope(Rails.env.production? ? '/demo' : '') do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords',
      confirmations: 'users/confirmations'
    }

    scope module: 'users' do
      resource :profile, except: [:destroy], controller: :profile, path: '/user/profile', as: 'user_profile'
      get '/profiles/:username', to: 'profile#show', as: 'profiles'
    end

    resource :user, only: [:none] do
      resource :address, except: [:show, :destroy]
      resource :avatar, controller: :pictures, only: [:create, :update, :destroy]
      resources :pages, param: 'pin', shallow: true do
        resource :address, except: [:show, :destroy]
        resource :logo, controller: :pictures, only: [:create, :update, :destroy]
      end
      # resources :chats, only: [:index, :show], param: :page
    end

    resources :pages, param: 'pin', only: [:none] do
      resources :posts
      resources :chats, only: [:index]
      resources :advertisements, shallow: true
    end

    resources :searches, param: :category, path: '/search', only: [:index, :show, :create]

    get 'chatrooms/:room', to: 'chats#show', as: 'chatroom'
    post 'chatrooms/:username/:page_pin', to: 'chats#create', as: 'chatrooms'

    post 'messages/:room', to: 'messages#create', as: 'message'

    get 'ads', to: 'advertisements_searches#index', as: 'ads'
    get 'ads/:id', to: 'advertisements_searches#show', as: 'ad'

    devise_scope :user do
      authenticated :user do
        root to: 'users/profile#show', as: :authenticated_root
      end
    end

    if Rails.env.production?
      unauthenticated do
        root to: "users/registrations#new", as: :demo_root
      end
    end
  end

  unauthenticated do
    root to: "creatives#index", as: :public_root
  end
end
