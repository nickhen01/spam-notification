require 'rails_helper'

RSpec.describe Slack::BouncedEmail::Spam do
  describe ".post_message" do
    it 'sends a message to slack' do
      expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage)

      params = { "Email" => "zaphod@example.com", "BouncedAt" => "2023-02-27T21:41:30Z" }

      described_class.post_message(params)
    end
  end

  describe "#post_message" do
    it 'sends a message to slack' do
      expect_any_instance_of(Slack::Web::Client).to receive(:chat_postMessage)

      params = { "Email" => "zaphod@example.com", "BouncedAt" => "2023-02-27T21:41:30Z" }

      bounced_email_spam = described_class.new(params)
      bounced_email_spam.post_message
    end
  end
end