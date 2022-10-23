Rails.application.routes.draw do
  get 'home/index'
  resources :payments
  resources :enrollments
  resources :students
  resources :institutions
  #  Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'home#index'
end
