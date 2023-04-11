require "rails_helper"

RSpec.describe "MarketVendors API" do
  before :each do
    MarketVendor.destroy_all
    Market.destroy_all
    Vendor.destroy_all

    @market = create(:market)
    @vendor = create(:vendor)

    @market_vendor_params = {
      market_id: @market.id,
      vendor_id: @vendor.id
    }

    @headers = { "CONTENT_TYPE" => "application/json" }
  end

  describe "POST #create and DELETE #destroy" do
    context "with valid attributes" do
      it "creates and deletes a new market vendor" do
        post "/api/v0/market_vendors",  headers: @headers,
                                        params:  JSON.generate(market_vendor: @market_vendor_params)

        expect(response.status).to eq(201)

        body = JSON.parse(response.body, symbolize_names: true)
        created_market_vendor = MarketVendor.last

        expect(body[:message]).to eq("Successfully added vendor to market")
        expect(created_market_vendor.market).to eq(@market)
        expect(created_market_vendor.vendor).to eq(@vendor)
        expect(created_market_vendor.market_id).to eq(@market_vendor_params[:market_id])
        expect(created_market_vendor.vendor_id).to eq(@market_vendor_params[:vendor_id])

        delete "/api/v0/market_vendors",  headers: @headers,
                                          params:  JSON.generate(market_vendor: @market_vendor_params)

        expect(response.status).to eq(204)
      end
    end
  end

  describe "POST #create" do
    context "without valid attributes" do
      it "returns bad request error if any attribute is missing with new market vendor post" do
        market_vendor_params = {
          market_id: "",
          vendor_id: @vendor.id
        }

        post "/api/v0/market_vendors",  headers: @headers,
                                        params:  JSON.generate(market_vendor: market_vendor_params)

        expect(response.status).to eq(400)

        body = JSON.parse(response.body, symbolize_names: true)
        error = body[:errors].first

        expect(error[:status]).to eq("BAD REQUEST")
        expect(error[:detail]).to eq("Validation Failed: Market must exist, Market can't be blank")
        expect(error[:code]).to eq(400)
      end

      it "returns not found error if market or vendor do not exist with new market vendor post" do
        vendor_id = 123

        market_vendor_params = {
          market_id: @market.id,
          vendor_id:
        }

        post "/api/v0/market_vendors",  headers: @headers,
                                        params:  JSON.generate(market_vendor: market_vendor_params)

        expect(response.status).to eq(404)

        body = JSON.parse(response.body, symbolize_names: true)
        error = body[:errors].first

        expect(error[:status]).to eq("NOT FOUND")
        expect(error[:detail]).to eq("Couldn't find Vendor with 'id'=123")
        expect(error[:code]).to eq(404)
      end

      it "returns bad request error if market_vendor association already exist" do
        market_vendor = MarketVendor.create(market_id: @market.id, vendor_id: @vendor.id)

        post "/api/v0/market_vendors",  headers: @headers,
                                        params:  JSON.generate(market_vendor: @market_vendor_params)

        expect(response.status).to eq(400)

        body = JSON.parse(response.body, symbolize_names: true)
        error = body[:errors].first

        expect(error[:status]).to eq("BAD REQUEST")
        expect(error[:detail]).to eq("Validation Failed: Market vendor asociation between market with market_id=#{@market.id} and vendor with vendor_id=#{@vendor.id} already exists")
        expect(error[:code]).to eq(400)
      end
    end

    context "without valid content-type" do
      it "returns bad request error with incorrect content type" do
        post "/api/v0/market_vendors", params: JSON.generate(market_vendor: @market_vendor_params)

        expect(response.status).to eq(400)

        body = JSON.parse(response.body, symbolize_names: true)
        error = body[:errors].first

        expect(error[:status]).to eq("BAD REQUEST")
        expect(error[:detail]).to eq("Validation Failed: JSON content type required")
        expect(error[:code]).to eq(400)
      end
    end
  end

  describe "DELETE #destroy" do
    context "without valid attributes" do
      it "returns not found error if market_vendor to be deleted does not exist" do
        vendor_id = 12_345

        market_vendor_params = {
          market_id: @market.id,
          vendor_id:
        }

        delete "/api/v0/market_vendors", headers: @headers,
                                         params:  JSON.generate(market_vendor: market_vendor_params)

        expect(response.status).to eq(404)

        body = JSON.parse(response.body, symbolize_names: true)
        error = body[:errors].first

        expect(error).to have_key(:status)
        expect(error[:status]).to eq("NOT FOUND")

        expect(error).to have_key(:detail)
        expect(error[:detail]).to eq("No MarketVendor with market_id=#{@market.id} AND vendor_id=#{vendor_id} exists")

        expect(error).to have_key(:code)
        expect(error[:code]).to eq(404)
      end
    end
  end
end
