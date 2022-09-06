Rails.application.routes.draw do
  devise_for :users,controllers: {
    sessions:      'users/sessions',
    registrations: 'users/registrations'
  }
  
  namespace :users do
    resources :users, path: '/', except: %i[create]
  end
  
  resources :recipes, controller: 'restaurants/recipes'
  resources :plans, controller: 'restaurants/plans'

  get 'restaurant/plans/active_users', to: 'restaurants/plans#active_users'
  get 'restaurant/plans/:id/buy', to: 'restaurants/plans#buy_plan', as: 'buy_plan'

end
