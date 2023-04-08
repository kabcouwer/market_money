module Api
  module V0
    class MarketsController < ApplicationController
      def index
        @markets = Market.all
        render json: MarketSerializer.new(@markets)
      end

      def show
        @market = MarketFacade.find_with_id(params[:id])
        if @market.instance_of?(Market)
          render json: MarketSerializer.new(@market)
        else
          render json: ErrorSerializer.new(@market).serialized_json
        end
      end
    end
  end
end
