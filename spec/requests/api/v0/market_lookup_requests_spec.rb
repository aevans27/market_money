require 'rails_helper'

RSpec.describe "Find markets by search" do
  before(:each) do
    market1 = create(:market, state: "Colorado", city: "Denver", name: "Douglas")
    market2 = create(:market, state: "Colorado", city: "Denver", name: "Littleton" )
    market3 = create(:market, state: "California", city: "Sacramento", name: "Orange")
    market4 = create(:market, state: "Texas", city: "Dallas", name: "Horse")
    market5 = create(:market, state: "New York", city: "New York", name: "New York")
  end

  it "find markets by state city" do
    get "/api/v0/markets/search?state=colorado&city=denver"
    found_markets = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(found_markets.count).to eq(2)
  end

  it "find markets by state name" do
    get "/api/v0/markets/search?state=colorado&name=douglas"
    found_markets = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(found_markets.count).to eq(1)
  end

  it "find markets by state" do
    get "/api/v0/markets/search?state=colorado"
    found_markets = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(found_markets.count).to eq(2)
  end

  it "find markets by city" do
    get "/api/v0/markets/search?name=douglas"
    found_markets = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(found_markets.count).to eq(1)
  end

  it "find markets by state city name" do
    get "/api/v0/markets/search?city=denver&state=colorado&name=littleton"
    found_markets = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(found_markets.count).to eq(1)
  end

  it "error if name used" do
    get "/api/v0/markets/search?city=denver"

    market = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(422)
    expect(market).to have_key(:errors)
    expect(market[:errors]).to eq([{:detail=>  "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."}])
  end

  it "error if name city used" do
    get "/api/v0/markets/search?city=denver&name=douglas"

    market = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(422)
    expect(market).to have_key(:errors)
    expect(market[:errors]).to eq([{:detail=>  "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."}])
  end

  it "error if nothing used" do
    get "/api/v0/markets/search"

    market = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(422)
    expect(market).to have_key(:errors)
    expect(market[:errors]).to eq([{:detail=>  "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."}])
  end

end