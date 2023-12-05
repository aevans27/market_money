require 'rails_helper'

describe "Internal api vendors" do
  it "checks all return from api/vendors" do
    create_list(:vendor, 3)
    get '/api/v0/vendors'

    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)
    vendors = response_body[:data]
    expect(vendors.count).to eq(3)

    vendors.each do |vendor|
      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes][:name]).to be_an(String)

      # expect(vendor[:attributes]).to have_key(:description)
      # expect(vendor[:attributes][:description]).to be_an(String)
      # expect(vendor[:attributes]).to have_key(:unit_price)
      # expect(vendor[:attributes][:unit_price].to_f).to be_an(Float)

      # expect(vendor[:attributes]).to have_key(:merchant_id)
      # expect(vendor[:attributes][:merchant_id].to_i).to be_an(Integer)
    end
  end

  it "can get one vendor by its id" do
    vendor_list = create_list(:vendor, 3)
  
    get "/api/v0/vendors/#{vendor_list.last.id}"
  
    response_body = JSON.parse(response.body, symbolize_names: true)
    vendor = response_body[:data]
  
    expect(response).to be_successful
  
    expect(vendor[:attributes]).to have_key(:name)
    expect(vendor[:attributes][:name]).to be_an(String)

    # expect(vendor[:attributes]).to have_key(:description)
    # expect(vendor[:attributes][:description]).to be_an(String)

    # expect(vendor[:attributes]).to have_key(:unit_price)
    # expect(vendor[:attributes][:unit_price].to_f).to be_an(Float)

    # expect(vendor[:attributes]).to have_key(:merchant_id)
    # expect(vendor[:attributes][:merchant_id].to_i).to be_an(Integer)
  end

  it "vendor doesn't exist" do
    get "/api/v0/vendors/1"

    vendor = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(vendor).to have_key(:errors)
    expect(vendor[:errors]).to eq("The vendor you are looking for does not exist")
  end

  it "create and destroy vendor" do
    post '/api/v0/vendors'
  end
end