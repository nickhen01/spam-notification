module Api
  module V1
    class BounceReportsController < BaseController
      def create
        if params["Type"] == "SpamNotification"
          Slack::BouncedEmail::Spam.post_message(params)

          render json: { message: 'The spam report has been posted to Slack.' }, status: 200
        else
          render json: { message: 'No further action.' }, status: 200
        end
      end
    end
  end
end