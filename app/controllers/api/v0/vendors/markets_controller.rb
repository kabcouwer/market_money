module Api
  module V0
    module Vendors
      class MarketsController < ApplicationController
        def index
          @vendor = VendorFacade.find_with_id(params[:vendor_id])
          if @vendor.instance_of?(Vendor)
            render json: MarketSerializer.new(@vendor.markets)
          else
            render json: ErrorSerializer.new(@vendor).serialized_json, status: :not_found
          end
        end
      end
    end
  end
end
