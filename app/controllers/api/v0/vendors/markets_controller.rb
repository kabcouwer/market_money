module Api
  module V0
    module Vendors
      class MarketsController < ApplicationController
        def index
          @vendor = Vendor.find(params[:vendor_id])
          render json: MarketSerializer.new(@vendor.markets)
        end
      end
    end
  end
end
