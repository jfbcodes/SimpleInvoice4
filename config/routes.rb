Rails.application.routes.draw do
  devise_for :users

  namespace :admin_dashboard do
    # on the admin dashboard I can see & edit all records (god controllers)
    resources :invoices # admin/invoices_controller.rb

    resources :users do # admin/users_controller.rb
      resources :invoices # admin/invoices_controller.rb
    end
  end

  namespace :user_dashboard do
    # on the user dashboard I can see & edit only my records
    resources :users do # users_controller.rb
      resources :invoices # invoices_controller.rb
    end
  end
end
