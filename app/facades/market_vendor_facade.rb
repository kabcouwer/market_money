class MarketVendorFacade
  def self.valid_create_request?(params)
    @market = MarketFacade.find_with_id(params[:market_id])
    @vendor = VendorFacade.find_with_id(params[:vendor_id])

    if params[:market_id].present? && @market.instance_of?(Error)
      @market
    elsif params[:vendor_id].present? && @vendor.instance_of?(Error)
      @vendor
    else
      MarketVendor.find_or_create_by(params)
    end
  end

  def self.find_with_params(params)
    MarketVendor.find_by(params)
  rescue ActiveRecord::RecordNotFound
    Error.new(
      "No MarketVendor with market_id= #{params[:market_id]} AND vendor_id= #{params[:vendor_id]} exists", "NOT FOUND", 404
    )
  end
end
