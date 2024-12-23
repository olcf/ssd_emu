Rails.application.routes.draw do
  resources :projects

  resources :jobs
  patch 'jobs/run/:id', to: 'jobs#run'
  get 'machines/:id/run', to:'machines#runCommand'
  resources :machines
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
