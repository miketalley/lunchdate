Rails.application.routes.draw do

  devise_for :users
  # Root Route
  root 'home#index'

  # Query paths for finding location
  get 'lunch_dates/new_query' => 'lunch_dates#new_query', as: 'new_query'
  post 'lunch_dates/query_result' => 'lunch_dates#query_result', as: 'query_result'


  # Twilio Route
  post 'twilio/voice' => 'twilio#voice'


  post 'lunch_dates/new' => 'lunch_dates#create'
  post 'lunch_dates/:id' => 'lunch_dates#accept_date', as: 'accept_date'
  get 'lunch_dates/:id/confirm_date' => 'lunch_dates#confirm_date', as: 'confirm_date'
  get 'lunch_dates/my_dates' => 'lunch_dates#my_dates', as: 'my_dates'
  get 'profiles/:id' => 'profiles#show', as: 'profile'

  resources :lunch_dates

end
