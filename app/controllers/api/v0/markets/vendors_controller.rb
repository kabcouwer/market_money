module Api
  module V0
    module Markets
      class VendorsController < ApplicationController
        def index
          @market = MarketFacade.find_with_id(params[:market_id])
          if @market.instance_of?(Market)
            render json: VendorSerializer.new(@market.vendors)
          else
            render json: ErrorSerializer.new(@market).serialized_json
          end
        end
      end
    end
  end
end
