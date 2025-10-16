Rails.application.routes.draw do
  devise_for :admins, skip: [:registrations]

  # Example routes
  root to: "home#index"
  
  namespace :admin do
    get "dashboard/index"
    root to: "dashboard#index"  # admin dashboard
  end

  # config/routes.rb
  namespace :admin do
    scope ':model', controller: 'dynamic_crud' do
      get '/', action: :index, as: :dynamic_crud_index
      get '/new', action: :new, as: :dynamic_crud_new
      post '/', action: :create, as: :dynamic_crud_create
      get '/:id/edit', action: :edit, as: :dynamic_crud_edit
      patch '/:id', action: :update, as: :dynamic_crud_update
      delete '/:id', action: :destroy, as: :dynamic_crud_destroy
      post '/import', action: :import, as: :dynamic_crud_import
      get '/export', action: :export, as: :dynamic_crud_export
    end
  end

end
