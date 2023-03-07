Slack.configure do |config|
  config.token = Rails.application.credentials[Rails.env.to_sym].dig(:slack_api_token)
end
