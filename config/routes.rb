Rails.application.routes.draw do
  resources :payments
  resources :enrollments
  resources :students
  resources :institutions
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
