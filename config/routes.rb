Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {
    omniauth_callbacks: 'oauth_callbacks',
    confirmations: 'email_confirmations'
  }

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]

  concern :votable do
    member do
      post :positive, :negative
      delete :revote
    end
  end

  concern :commentable do
    resources :comments
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, concerns: %i[votable commentable], shallow: true do
      patch :best, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
