class Api::V0::MarketsLookupController < ApplicationController
  def show
    headers = {"CONTENT_TYPE" => "application/json"}
    if params[:state].present? && params[:city].present? && params[:name].present?
      markets = Market.find_by_3(params[:state], params[:name], params[:city])
      render json: MarketSerializer.new(markets), headers: headers
    elsif params[:state].present? && params[:city].present?
      markets = Market.find_by_state_and_city(params[:state], params[:city])
      render json: MarketSerializer.new(markets), headers: headers
    elsif params[:state].present? && params[:name].present?
      markets = Market.find_by_state_and_name(params[:state], params[:name])
      render json: MarketSerializer.new(markets), headers: headers
    elsif params[:city].present? && params[:name].present?
      render json: {
        "errors": [
            {
                "detail": "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."
            }
        ]
      }, status: 422
    elsif params[:name].present?
      markets = Market.find_by_name(params[:name])
      render json: MarketSerializer.new(markets), headers: headers
    elsif params[:state].present?
      markets = Market.find_by_state(params[:state])
      render json: MarketSerializer.new(markets), headers: headers
    elsif params[:city].present?
      render json: {
        "errors": [
            {
                "detail": "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."
            }
        ]
      }, status: 422
    else
      render json: {
        "errors": [
            {
                "detail": "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint."
            }
        ]
      }, status: 422
    end
  end
end