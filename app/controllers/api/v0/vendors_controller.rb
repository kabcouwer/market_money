module Api
  module V0
    class VendorsController < ApplicationController
      before_action :find_vendor, only: %i[show update destroy]
      before_action :check_content_type, only: %i[create update]

      def show
        render json: VendorSerializer.new(@vendor)
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
        if @vendor.update(vendor_params)
          render json: VendorSerializer.new(@vendor)
        else
          bad_request(@vendor.errors.full_messages)
        end
      end

      def destroy
        return unless @vendor.destroy

        render status: :no_content
      end

      private

      def find_vendor
        @vendor = Vendor.find(params[:id])
      end

      def vendor_params
        params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone,
                                       :credit_accepted)
      end
    end
  end
end
