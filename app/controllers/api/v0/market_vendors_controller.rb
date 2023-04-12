module Api
  module V0
    class MarketVendorsController < ApplicationController
      before_action :check_content_type, :find_market, :find_vendor, only: [:create]
      before_action :find_market_vendor, only: [:destroy]

      def create
        @market_vendor = MarketVendor.new(market_vendor_params)
        if @market_vendor.save
          render json: { message: "Successfully added vendor to market" }, status: :created
        elsif !@market || !@vendor
          bad_request(@market_vendor.errors.full_messages)
        else
          unprocessable_entity(@market_vendor.errors.full_messages)
        end
      end

      def destroy
        unless @market_vendor&.destroy
          raise "No MarketVendor with market_id=#{market_vendor_params[:market_id]} "\
          "AND vendor_id=#{market_vendor_params[:vendor_id]} exists"
        end

        render status: :no_content
      end

      private

      def find_market
        return if market_vendor_params[:market_id].blank?

        @market = Market.find(market_vendor_params[:market_id])
      end

      def find_vendor
        return if market_vendor_params[:vendor_id].blank?

        @vendor = Vendor.find(market_vendor_params[:vendor_id])
      end

      def find_market_vendor
        return if market_vendor_params[:market_id].blank? || market_vendor_params[:vendor_id].blank?

        @market_vendor = MarketVendor.find_by(market_vendor_params)
      end

      def market_vendor_params
        params.require(:market_vendor).permit(:market_id, :vendor_id)
      end
    end
  end
end
