module Api
  module V0
    module Markets
      class VendorsController < ApplicationController
        def index
          @market = Market.find(params[:market_id])
          render json: VendorSerializer.new(@market.vendors)
        end
      end
    end
  end
end
