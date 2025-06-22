Rails.application.routes.draw do
  resources :chapters do
    member do
      post :complete
    end
  end
  resources :quizzes
  resources :missions do
    member do
      post :check_completion
    end
  end
  get 'mission_with_chapters/:id', to: 'missions#mission_with_chapters'
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
