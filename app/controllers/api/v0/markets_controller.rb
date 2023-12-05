class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    if Market.exists?(params[:id])
      render json: MarketSerializer.new(Market.find(params[:id]))
    else
      render json: {errors: "The market you are looking for does not exist"}, status: 404
    end
  end
end