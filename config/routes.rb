Rails.application.routes.draw do
  devise_for :members, controllers: { omniauth_callbacks: 'members/omniauth_callbacks' }
  devise_scope :member do
    get 'members/sign_in', to: 'members/sessions#new', as: :new_member_session
    get 'members/sign_out', to: 'members/sessions#destroy', as: :destroy_member_session
  end

  get 'help', to: 'pages#help'
  post 'help', to: 'pages#help'
  get 'faq_member', to: 'pages#faq_member'
  get 'faq_officer', to: 'pages#faq_officer'

  resources :roles

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :member_roles do
    member do
      put 'approve'
      put 'reject'
    end

    collection do
      get 'approval'
    end
  end
  
  resources :members do
    member do
      get 'delete_confirmation'
    end

    collection do
      get :sort
    end
  end

  root "dashboards#show"

  resources :events do
    get 'delete_confirmation', on: :member
    # attendees resources
    resources :attendees do
      collection do
        get 'check_in'
        get 'new_check_in'
      end
      member do
        get 'delete'
      end
    end
    # end attendees resources
    member do
      get 'delete'
    end
  end

  resources :notifications do
    member do
      get 'delete_confirmation'
    end
  end
  resources :member_notifications do
    member do
      patch 'mark_seen'
    end
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
