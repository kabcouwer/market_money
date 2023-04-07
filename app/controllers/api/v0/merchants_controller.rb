class MerchantsController << ApplicationController
  def index
    render json: Merchant.all
  end
end