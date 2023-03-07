require 'rails_helper'

RSpec.describe "/api/v1", type: :request do
  before do
    Rails.application.routes.draw do
      get "/api/test" => "test#index"
    end
  end

  after do
    Rails.application.reload_routes!
  end

  context "when the request provides a valid api token" do
    it "allows the request to pass" do
      headers = { "Content-Type" => "application/json", "Authorization" => "Bearer #{Rails.application.credentials[Rails.env.to_sym].dig(:app_api_token)}" }

      get "/api/test", headers: headers

      expect(response).to be_successful
    end
  end

  context "when the request provides an invalid api token" do
    it "does not allow the request to pass" do
      headers = { "Content-Type" => "application/json", "Authorization" => "Bearer 1234" }

      get "/api/test", headers: headers

      expect(response).to be_unauthorized
    end
  end

  context "when the request provides no api token" do
    it "does not allow the request to pass" do
      get "/api/test"

      expect(response).to be_unauthorized
    end
  end

  private

  TestController = Class.new(Api::V1::BaseController) do
    def index
      render json: { message: "Hello world!" }
    end
  end
end