require 'rails_helper'

describe "Nearest atm from api call" do
  it "checks for return of atm" do
    market = create(:market, lat: 80, lon: 70)
  
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    get "/api/v0/markets/#{market.id}/nearest_atms"
    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)
    atms = response_body[:data]
    expect(atms.count).to eq(10)

    atms.each do |atm|
      expect(atm[:attributes]).to have_key(:name)
      expect(atm[:attributes][:name]).to be_an(String)
    end
  end

  it "no atm since market doesn't exist" do
    get "/api/v0/markets/1/nearest_atms"
    
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(response_body).to have_key(:errors)
  end
end