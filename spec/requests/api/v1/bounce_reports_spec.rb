require 'rails_helper'

RSpec.describe "/api/v1/bounce_reports", type: :request do
  let(:headers) {
    { "Content-Type" => "application/json", "Authorization" => "Bearer #{Rails.application.credentials[Rails.env.to_sym].dig(:app_api_token)}" }
  }

  before do
    allow(Slack::BouncedEmail::Spam).to receive(:post_message)
  end

  describe "POST /create" do
    context "when bounced due to spam" do
      let(:params) do
        {
          "RecordType": "Bounce",
          "Type": "SpamNotification",
          "TypeCode": 512,
          "Name": "Spam notification",
          "Tag": "",
          "MessageStream": "outbound",
          "Description": "The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.",
          "Email": "zaphod@example.com",
          "From": "notifications@honeybadger.io",
          "BouncedAt": "2023-02-27T21:41:30Z",
        }.to_json
      end

      it 'returns a successful response' do
        post api_v1_bounce_reports_url, headers: headers, params: params

        expect(response).to be_successful
      end

      it 'includes the correct message in the response' do
        post api_v1_bounce_reports_url, headers: headers, params: params

        expect(JSON.parse(response.body)['message']).to eq 'The spam report has been posted to Slack.'
      end

      it 'posts a bounce spam notification to Slack' do
        post api_v1_bounce_reports_url, headers: headers, params: params

        expect(Slack::BouncedEmail::Spam).to have_received(:post_message)
      end
    end

    context "when not bounced due to spam" do
      let(:params) do
        {
          "RecordType": "Bounce",
          "MessageStream": "outbound",
          "Type": "HardBounce",
          "TypeCode": 1,
          "Name": "Hard bounce",
          "Tag": "Test",
          "Description": "The server was unable to deliver your message (ex: unknown user, mailbox not found).",
          "Email": "arthur@example.com",
          "From": "notifications@honeybadger.io",
          "BouncedAt": "2019-11-05T16:33:54.9070259Z",
        }.to_json
      end

      it 'returns a successful response' do
        post api_v1_bounce_reports_url, headers: headers, params: params

        expect(response).to be_successful
      end

      it 'includes the correct message in the response' do
        post api_v1_bounce_reports_url, headers: headers, params: params

        expect(JSON.parse(response.body)['message']).to eq 'No further action.'
      end

      it 'does not post a bounce spam notification to Slack' do
        post api_v1_bounce_reports_url, headers: headers, params: params

        expect(Slack::BouncedEmail::Spam).not_to have_received(:post_message)
      end
    end
  end
end