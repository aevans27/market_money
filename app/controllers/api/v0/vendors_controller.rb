class Api::V0::VendorsController < ApplicationController
  def index
    if params[:market_id].present?
      if Market.exists?(params[:market_id])
        render json: VendorSerializer.new(Market.find(params[:market_id]).vendors)
      else
        render json: {errors: "The market you are looking for does not exist"}, status: 404
      end
    else 
      render json: VendorSerializer.new(Vendor.all)
    end
  end

  def show
    if Vendor.exists?(params[:id])
      render json: VendorSerializer.new(Vendor.find(params[:id]))
    else
      render json: {errors: "The vendor you are looking for does not exist"}, status: 404
    end
  end

  def create
    # require 'pry';binding.pry
    if !Vendor.exists?(params[:vendor][:name])
      if params[:vendor][:contact_name] != nil && params[:vendor][:contact_phone] != nil
        vendor = Vendor.new(name: params[:vendor][:name],
        description: params[:vendor][:description],
        contact_name: params[:vendor][:contact_name],
        contact_phone: params[:vendor][:contact_phone],
        credit_accepted: params[:vendor][:credit_accepted])
        if vendor.save
          # require 'pry';binding.pry
          render json: VendorSerializer.new(vendor), status: 201
        else
          render json: {errors: "Something went wrong with vendor creation"}, status: 400
        end
      else
        render json: {errors: [
          {
              "detail": "Validation failed: Contact name can't be blank, Contact phone can't be blank"
          }
      ]}, status: 400
      end
    else 
      render json: {errors: "Something went wrong with vendor creation"}, status: 400
    end
  end

  def destroy
    # require 'pry';binding.pry
    if Vendor.exists?(params[:id])
      vendor = Vendor.find(params[:id])
      vendor.destroy
      render json: {data: "The vendor is deleted"}, status: 204
    else
      render json: {errors: "The vendor you are looking for does not exist"}, status: 400
    end
  end
end