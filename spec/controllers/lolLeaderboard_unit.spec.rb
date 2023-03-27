require 'rails_helper'

RSpec.describe LolController, type: :controller do
  describe "GET leaderboardAPI" do
    it "returns a JSON response" do
      riot_key = Rails.application.credentials[:riot_key]
      region = 'EUW1'
      queue_type = 'RANKED SOLO 5X5'
      params = { region: region, queueType: queue_type }
      allow(HTTP).to receive(:get).with("https://#{region}.api.riotgames.com/lol/league/v4/challengerleagues/by-queue/#{queue_type}", params: { api_key: riot_key }).and_return({ "entries" => [] })

      get :leaderboardAPI, params: params, format: :json

      expect(response.content_type).to eq("application/json")
      expect(response.body).to eq("{\"entries\":[]}")
    end
  end
end