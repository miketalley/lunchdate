Rails.application.routes.draw do

  devise_for :users
  # Root Route
  root 'dates#index'

  # Twilio Route
  post 'twilio/voice' => 'twilio#voice'

  resources :dates

end
