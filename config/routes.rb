Rails.application.routes.draw do
  devise_for :admins, skip: [:registrations]

  # Example routes
  root to: "home#index"
  
  namespace :admin do
    get "dashboard/index"
    root to: "dashboard#index"  # admin dashboard
  end
end
