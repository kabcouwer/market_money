module Api
  module V0
    class MarketVendorsController < ApplicationController
      def new
        @market_vendor = MarketVendor.new
      end

      def create
        @market_vendor = MarketVendorFacade.valid_create_request?(market_vendor_params)
        if !@market_vendor.instance_of?(MarketVendor)
          render json: ErrorSerializer.new(@market_vendor).serialized_json, status: :not_found
        elsif @market_vendor.errors?
          bad_request(@market_vendor.errors.full_messages)
        elsif @market_vendor.persisted?
          render json: { message: "Successfully added vendor to market" }, status: :created
        else
          @error = Error.new(
            "Market vendor asociation between market with market_id= #{@market_vendor.market_id} and vendor_id= #{@market_vendor.vendor_id}already exists", "UNPROCESSABLE ENTITY", 422
          )
          render json: ErrorSerializer.new(@error).serialized_json, status: :unprocessable_entity
        end
      end

      def destroy
        @market_vendor = MarketVendorFacade.find_with_params(market_vendor_params)
        if !@market_vendor.instance_of?(MarketVendor)
          render json: ErrorSerializer.new(@market_vendor).serialized_json, status: :not_found
        elsif @market_vendor.destroy
          render status: :no_content
        end
      end

      private

      def market_vendor_params
        params.require(:market_vendor).permit(:market_id, :vendor_id)
      end
    end
  end
end
