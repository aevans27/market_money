require 'rails_helper'

describe "Find markets by search" do
  it "find markets by state city" do
    market1 = create(:market, state: "Colorado", city: "Denver")
    market2 = create(:market, state: "Colorado", city: "Denver")
    market3 = create(:market, state: "California")
    market4 = create(:market, state: "Texas")
    market5 = create(:market, state: "New York")
   
    get "/api/v0/markets/search?state=colorado&city=denver"
    found_markets = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(found_markets.count).to eq(2)
  end
end