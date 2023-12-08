class Api::V0::MarketVendorsController < ApplicationController

  def create
    if Vendor.exists?(params[:vendor_id]) && Market.exists?(params[:market_id]) 
      if MarketVendor.exists?(market_vendor_params)
        render json: {
          "errors": [
              {
                  "detail": "Validation failed: Market vendor asociation between market with market_id= #{params[:market_id]} and vendor_id= #{params[:vendor_id]} already exists"
              }
          ]
      }, status: 422
      else
        mc = MarketVendor.new(market_vendor_params)
        if mc.save
          render json: MarketVendorSerializer.new(mc), status: 201
        else
          render json: {errors: "Something went wrong with vendor creation"}, status: 400
        end
      end
    else 
      render json: {
        errors: [
            {
                "detail": "Validation failed: Market and Vendor must exist"
            }
        ]
      }, status: 404
    end
  end

  def destroy
    if MarketVendor.exists?(market_vendor_params)
      mc = MarketVendor.where(market_vendor_params).first
      mc.destroy
      render json: {data: "The market_vendor is deleted"}, status: 204
    else
      render json: {errors: "The vendor you are looking for does not exist"}, status: 400
    end
  end

  private
    def market_vendor_params
      params.require(:market_vendor).permit(:market_id, :vendor_id)
    end
end