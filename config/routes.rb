Rails.application.routes.draw do
  
  devise_for :users
  devise_scope :user do
    namespace :api do
      namespace :v1 do
        namespace :auth do
          post 'login', to: 'sessions#create'
          delete 'logout', to: 'sessions#destroy'
          post 'forgot', to: 'passwords#create'
          post 'register', to: 'registrations#create'
          put 'update-profile', to: 'registrations#update'
          delete 'delete-account', to: 'registrations#destroy'
        end
        resources :lists, except: [:new, :show, :edit] do
          resources :items, except: [:new, :show, :edit] do
            post 'toggle-done', action: :toggle_done, on: :member
          end
        end
        resources :categories, except: [:new, :show, :edit]
        get 'profile', to: 'users#profile'
      end
    end
  end
end
