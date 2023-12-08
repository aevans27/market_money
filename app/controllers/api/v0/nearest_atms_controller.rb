class Api::V0::NearestAtmsController < ApplicationController
  def index
    if Market.exists?(params[:market_id])
      market = Market.find(params[:market_id])
      facade = SearchFacade.new
      results = facade.nearest_atm(market[:lat], market[:lon])
      render json: AtmSerializer.new(results), status: 200
    else
      render json: {errors: "The market you are looking for does not exist"}, status: 404
    end
  end
end