require 'rails_helper'

describe "Internal api Merchants" do
  it "checks all return from api/merchants" do
    create_list(:market, 3)
    get '/api/v0/markets'

    response_body = JSON.parse(response.body, symbolize_names: true)
    markets = response_body[:data]
    expect(markets.count).to eq(3)
    expect(response).to be_successful

    markets.each do |market|
      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_an(String)
    end
  end

end