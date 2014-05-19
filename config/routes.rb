Rails.application.routes.draw do

  devise_for :users
  # Root Route
  root 'lunch_dates#index'

  # Twilio Route
  post 'twilio/voice' => 'twilio#voice'

  resources :dates

end
