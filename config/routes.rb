Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      defaults format: :json do
        resources :bounce_reports, only: [:create]
      end
    end
  end
end
