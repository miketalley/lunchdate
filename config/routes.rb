Rails.application.routes.draw do

  devise_for :users
  # Root Route
  root 'home#index'

  get 'lunch_dates/new_query' => 'lunch_dates#new_query', as: 'new_query'
  post 'lunch_dates/query_result' => 'lunch_dates#query_result', as: 'query_result'


  # Twilio Route
  post 'twilio/voice' => 'twilio#voice'

  post 'lunch_dates/new' => 'lunch_dates#create'
  post 'lunch_dates/:id' => 'lunch_dates#accept_date', as: 'accept_date'

  resources :lunch_dates

end
