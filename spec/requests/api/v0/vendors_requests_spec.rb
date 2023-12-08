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
  end

  it "vendor doesn't exist" do
    get "/api/v0/vendors/1"

    vendor = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(vendor).to have_key(:errors)
    expect(vendor[:errors]).to eq("The vendor you are looking for does not exist")
  end

  it "can destroy an vendor" do
    vendor = create(:vendor)
    expect(Vendor.count).to eq(1)
  
    delete "/api/v0/vendors/#{vendor.id}"
  
    expect(response).to be_successful
    
    expect(Vendor.count).to eq(0)
    expect{Vendor.find(vendor.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "cant destroy an vendor that doesn't exists" do
    delete "/api/v0/vendors/1"
  
    vendor = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(vendor).to have_key(:errors)
    expect(vendor[:errors]).to eq("The vendor you are looking for does not exist")
  end

  it "can update an existing vendor" do
    vendor = create(:vendor)
    previous_name = vendor.name
    vendor_params = { name: "Bubba",
    description: vendor.description,
    contact_name: vendor.contact_name,
    contact_phone: vendor.contact_phone,
    credit_accepted: vendor.credit_accepted }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate({vendor: vendor_params})
    new_vendor = Vendor.find_by(id: vendor.id)
    expect(response.status).to eq(200)
    expect(response).to be_successful
    # require 'pry';binding.pry
    expect(new_vendor.name).to_not eq(previous_name)
    expect(new_vendor.name).to eq("Bubba")
  end

  it "error when updating vendor with bad id" do
    vendor = create(:vendor)
    vendor_params = { name: "Bubba Soda", description:"Bad Soda", unit_price: 2.01, merchant_id: 0 }
    headers = {"CONTENT_TYPE" => "application/json"}
    patch "/api/v0/vendors/9999999999", headers: headers, params: JSON.generate({vendor: vendor_params})

    vendor = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(vendor).to have_key(:errors)
    expect(vendor[:errors]).to eq([{:detail=>"Couldn't find Vendor with 'id'= 9999999999"}])
  end

  it "error when updating vendor withouth contact name and phone" do
    vendor = create(:vendor)
    previous_name = vendor.name
    vendor_params = { name: "Bubba",
    description: vendor.description,
    contact_name: nil,
    contact_phone: nil,
    credit_accepted: vendor.credit_accepted }
    headers = {"CONTENT_TYPE" => "application/json"}
    patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate({vendor: vendor_params})

    vendor = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(vendor).to have_key(:errors)
    expect(vendor[:errors]).to eq("Missing contact name or number")
  end

  it "check for successful creation vendors" do
    vendor_params = { name: "Bobs",
    description: "Bobs place", contact_name: "Jim", contact_phone: "55555555", credit_accepted: true }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor_params)

    expect(response).to be_successful
    response_body = JSON.parse(response.body, symbolize_names: true)
    vendor = response_body[:data]
    expect(vendor.count).to eq(3)

      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes]).to have_key(:contact_phone)
  end

  it "check for failed creation vendors" do
    vendor_params = { name: "Bobs",
    description: "Bobs place", contact_name: nil, contact_phone: nil, credit_accepted: true }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor_params)

    vendor = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(vendor).to have_key(:errors)
    expect(vendor[:errors]).to eq([{:detail=>  "Validation failed: Contact name can't be blank, Contact phone can't be blank"}])
  end
end