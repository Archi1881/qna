Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

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

  mount ActionCable.server => '/cable'
end
