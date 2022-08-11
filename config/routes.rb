Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]

  resources :questions do
    resources :answers, shallow: true do
      patch :best, on: :member
    end
  end
end
