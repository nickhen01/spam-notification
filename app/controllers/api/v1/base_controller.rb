module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authenticate

      private

      def authenticate
        authenticate_or_request_with_http_token do |token, _options|
          ActiveSupport::SecurityUtils.secure_compare(token, ENV['APP_API_TOKEN'])
        end
      end
    end
  end
end