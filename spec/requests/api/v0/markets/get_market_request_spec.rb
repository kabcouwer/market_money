require "rails_helper"

RSpec.describe "Markets API" do
  describe "GET #show" do
    context "with valid attributes" do
      it "gets one market" do
        market1 = create(:market)
        vendor1 = create(:vendor)
        vendor2 = create(:vendor)
        vendor3 = create(:vendor)
        market_vendor1 = MarketVendor.create(market_id: market1.id, vendor_id: vendor1.id)
        market_vendor2 = MarketVendor.create(market_id: market1.id, vendor_id: vendor2.id)
        market_vendor3 = MarketVendor.create(market_id: market1.id, vendor_id: vendor3.id)

        get "/api/v0/markets/#{market1.id}"

        expect(response.status).to eq(200)

        body = JSON.parse(response.body, symbolize_names: true)
        market = body[:data]

        expect(market).to have_key(:id)
        expect(market[:id]).to be_a(String)
        expect(market[:id]).to eq(market1.id.to_s)

        expect(market).to have_key(:type)
        expect(market[:type]).to eq("market")

        expect(market).to have_key(:attributes)
        expect(market[:attributes].count).to eq(9)

        expect(market[:attributes][:name]).to eq(market1.name)
        expect(market[:attributes][:street]).to eq(market1.street)
        expect(market[:attributes][:city]).to eq(market1.city)
        expect(market[:attributes][:county]).to eq(market1.county)
        expect(market[:attributes][:state]).to eq(market1.state)
        expect(market[:attributes][:zip]).to eq(market1.zip)
        expect(market[:attributes][:lat]).to eq(market1.lat)
        expect(market[:attributes][:lon]).to eq(market1.lon)
        expect(market[:attributes][:vendor_count]).to eq(market1.vendor_count)
      end
    end

    context "without valid attributes" do
      it "returns 404 with bad market id" do
        id = 12_345

        get "/api/v0/markets/#{id}"

        expect(response.status).to eq(404)

        body = JSON.parse(response.body, symbolize_names: true)
        error = body[:errors].first

        expect(error).to have_key(:status)
        expect(error[:status]).to eq("NOT FOUND")

        expect(error).to have_key(:detail)
        expect(error[:detail]).to eq("Couldn't find Market with 'id'=12345")

        expect(error).to have_key(:code)
        expect(error[:code]).to eq(404)
      end
    end
  end
end
