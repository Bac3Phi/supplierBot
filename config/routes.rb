Rails.application.routes.draw do
  resources :posts

  devise_for :users
  
  root to: 'posts#index'

  resources :profiles do
    post :import, on: :collection
    delete :destroy_all, on: :collection
  end

  resources :invoices do
    post :import, on: :collection
    delete :destroy_all, on: :collection
    post :send_emails, on: :collection
  end
end
