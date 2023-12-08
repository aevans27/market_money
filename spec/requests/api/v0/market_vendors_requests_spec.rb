require 'rails_helper'

describe "Internal api market vendors" do
  it "check for successful creation api/market_vendors" do
    market = create(:market)
    vendor = create(:vendor)
    mc_params = { market_id: market.id,
    vendor_id: vendor.id }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post "/api/v0/market_vendors", headers: headers, params: JSON.generate(mc_params)

    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)
    mc = response_body[:data]
    expect(mc.count).to eq(3)

      expect(mc[:attributes]).to have_key(:market_id)
      expect(mc[:attributes]).to have_key(:vendor_id)
  end

  it "checks for error if mc exists" do
    market = create(:market)
    vendor = create(:vendor)
    create(:market_vendor, market_id: market.id, vendor_id: vendor.id)
    mc_params = { market_id: market.id,
    vendor_id: vendor.id }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post "/api/v0/market_vendors", headers: headers, params: JSON.generate(mc_params)
  
    mc = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(422)
    expect(mc).to have_key(:errors)
  end

  it "checks for error if vendor or market doesn't exist" do
    mc_params = { market_id: 0,
    vendor_id: 0 }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post "/api/v0/market_vendors", headers: headers, params: JSON.generate(mc_params)
    mc = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(mc).to have_key(:errors)
  end

  it "can destroy an market_vendor" do
    market = create(:market)
    vendor = create(:vendor)
    mc = create(:market_vendor, market_id: market.id, vendor_id: vendor.id)

    mc_params = { id: mc.id }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    expect(MarketVendor.count).to eq(1)
  
    delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(mc_params)
  
    expect(response).to be_successful
    
    expect(MarketVendor.count).to eq(0)
    expect{MarketVendor.find(mc.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "cant destroy an market_vendor that doesn't exists" do
    # mc = create(:market_vendor, market_id: market.id, vendor_id: vendor.id)
    mc_params = { id: 0 }

    headers = {"CONTENT_TYPE" => "application/json"}
    delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(mc_params)
  
    mc = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(mc).to have_key(:errors)
    expect(mc[:errors]).to eq("The vendor you are looking for does not exist")
  end
end