module Api
  module V0
    class VendorsController < ApplicationController
      def show
        @vendor = VendorFacade.find_with_id(params[:id])
        if @vendor.instance_of?(Vendor)
          render json: VendorSerializer.new(@vendor)
        else
          render json: ErrorSerializer.new(@vendor).serialized_json, status: :not_found
        end
      end

      def new
        @vendor = Vendor.new
      end

      def create
        @vendor = Vendor.new(vendor_params)
        if @vendor.save
          render json: VendorSerializer.new(@vendor), status: :created
        else
          bad_request(@vendor.errors.full_messages)
        end
      end

      def update
        @vendor = VendorFacade.find_with_id(params[:id])
        if !@vendor.instance_of?(Vendor)
          render json: ErrorSerializer.new(@vendor).serialized_json, status: :not_found
        elsif @vendor.update(vendor_params)
          render json: VendorSerializer.new(@vendor)
        else
          bad_request(@vendor.errors.full_messages)
        end
      end

      def destroy
        @vendor = VendorFacade.find_with_id(params[:id])
        if @vendor.instance_of?(Vendor)
          @vendor.destroy
        else
          render json: ErrorSerializer.new(@vendor).serialized_json, status: :not_found
        end
      end

      private

      def vendor_params
        params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone,
                                       :credit_accepted)
      end
    end
  end
end
