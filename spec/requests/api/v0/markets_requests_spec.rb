require 'rails_helper'

describe "Internal api Markets" do
  it "checks all return from api/markets" do
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
  
  it "can get market by id" do
    market = create(:market, name:"Bobs Market")
    get "/api/v0/markets/#{market.id}"

    response_body = JSON.parse(response.body, symbolize_names: true)
    markets = response_body[:data]
    
    expect(markets.count).to eq(3)
    expect(response).to be_successful

    expect(markets[:attributes]).to have_key(:name)
    expect(markets[:attributes][:name]).to be_an(String)
  end

  it "get 404 from bad merchant id" do
    get "/api/v0/markets/1"
    
    market = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(market).to have_key(:errors)
    expect(market[:errors]).to eq("The market you are looking for does not exist")
  end

  it "can get market vendors" do
    market = create(:market)
    vendor = create(:vendor)
    create(:market_vendor, market_id: market.id, vendor_id: vendor.id)
  
    get "/api/v0/markets/#{market.id}/vendors"
  
    response_body = JSON.parse(response.body, symbolize_names: true)
    vendor_response = response_body[:data]
  
    expect(response).to be_successful
  
    vendor_response.each do |vendor|
      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes][:name]).to be_an(String)
    end
  end

  it "error if market id is invalid" do
    market = create(:market)
    vendor = create(:vendor)
    create(:market_vendor, market_id: market.id, vendor_id: vendor.id)
  
    get "/api/v0/markets/999999999/vendors"
    market = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(market).to have_key(:errors)
    expect(market[:errors]).to eq("The market you are looking for does not exist")
  end
end