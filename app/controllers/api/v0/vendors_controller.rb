module Api
  module V0
    class VendorsController < ApplicationController
      def show
        @vendor = VendorFacade.find_with_id(params[:id])
        if @vendor.instance_of?(Vendor)
          render json: VendorSerializer.new(@vendor)
        else
          render json: ErrorSerializer.new(@vendor).serialized_json
        end
      end
    end
  end
end
