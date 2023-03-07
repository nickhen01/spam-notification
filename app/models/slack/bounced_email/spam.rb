module Slack
  module BouncedEmail
    class Spam
      def self.post_message(params)
        bounced_email_spam = new(params)
        bounced_email_spam.post_message
      end

      def initialize(params)
        @params = params
      end

      def post_message
        slack_client.chat_postMessage(channel: channel, text: text)
      end

      private

      attr_reader :params

      def slack_client
        @slack_client ||= Slack::Web::Client.new
      end

      def channel
        Rails.application.credentials[Rails.env.to_sym].dig(:slack_channel)
      end

      def text
        "An email to #{params["Email"]} has bounced back as spam at #{DateTime.parse(params["BouncedAt"]).to_fs(:long)}."
      end
    end
  end
end