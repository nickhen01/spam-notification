module Api
  module V1
    class BaseController < ApplicationController
      TOKEN = Rails.application.credentials[Rails.env.to_sym].dig(:app_api_token)

      protect_from_forgery with: :null_session

      before_action :authenticate

      private

      def authenticate
        authenticate_or_request_with_http_token do |token, _options|
          ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
        end
      end
    end
  end
end