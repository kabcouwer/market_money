require "rails_helper"

RSpec.describe "Vendors Markets API" do
  describe "GET #index" do
    context "happy paths" do
      it "gets all markets for a vendor" do
        vendor1 = create(:vendor)
        vendor2 = create(:vendor)

        market1 = create(:market)
        market2 = create(:market)
        market3 = create(:market)

        market_vendor1 = MarketVendor.create(market_id: market1.id, vendor_id: vendor1.id)
        market_vendor2 = MarketVendor.create(market_id: market2.id, vendor_id: vendor1.id)
        market_vendor2 = MarketVendor.create(market_id: market3.id, vendor_id: vendor1.id)
        market_vendor3 = MarketVendor.create(market_id: market1.id, vendor_id: vendor2.id)

        get "/api/v0/vendors/#{vendor1.id}/markets"

        expect(response.status).to eq(200)

        body = JSON.parse(response.body, symbolize_names: true)
        markets = body[:data]

        expect(markets.count).to eq(3)

        markets.each do |market|
          expect(market).to have_key(:id)
          expect(market[:id]).to be_a(String)
          expect(market[:id].to_i).to be_an(Integer)

          expect(market).to have_key(:type)
          expect(market[:type]).to eq("market")

          expect(market).to have_key(:attributes)
          expect(market[:attributes]).to be_a(Hash)
          expect(market[:attributes].count).to eq(9)

          expect(market[:attributes]).to have_key(:name)
          expect(market[:attributes][:name]).to be_a(String)
          expect(market[:attributes]).to have_key(:street)
          expect(market[:attributes][:street]).to be_a(String)
          expect(market[:attributes]).to have_key(:city)
          expect(market[:attributes][:city]).to be_a(String)
          expect(market[:attributes]).to have_key(:county)
          expect(market[:attributes][:county]).to be_a(String)
          expect(market[:attributes]).to have_key(:state)
          expect(market[:attributes][:state]).to be_a(String)
          expect(market[:attributes]).to have_key(:zip)
          expect(market[:attributes][:zip]).to be_a(String)
          expect(market[:attributes]).to have_key(:lat)
          expect(market[:attributes][:lat]).to be_a(String)
          expect(market[:attributes]).to have_key(:lon)
          expect(market[:attributes][:lon]).to be_a(String)
        end
      end

      it "gets an empty array if vendor has no markets" do
        vendor1 = create(:vendor)
        vendor2 = create(:vendor)

        market1 = create(:market)
        market2 = create(:market)
        market3 = create(:market)

        market_vendor1 = MarketVendor.create(market_id: market1.id, vendor_id: vendor1.id)
        market_vendor2 = MarketVendor.create(market_id: market2.id, vendor_id: vendor1.id)
        market_vendor2 = MarketVendor.create(market_id: market3.id, vendor_id: vendor1.id)

        get "/api/v0/vendors/#{vendor2.id}/markets"

        expect(response.status).to eq(200)

        body = JSON.parse(response.body, symbolize_names: true)
        markets = body[:data]

        expect(markets.count).to eq(0)
      end
    end

    context "sad paths" do
      it "returns 404 with bad vendor id" do
        id = 12_345

        get "/api/v0/vendors/#{id}/markets"

        expect(response.status).to eq(404)

        body = JSON.parse(response.body, symbolize_names: true)
        error = body[:errors].first

        expect(error).to have_key(:status)
        expect(error[:status]).to eq("NOT FOUND")

        expect(error).to have_key(:detail)
        expect(error[:detail]).to eq("Couldn't find Vendor with 'id'= 12345")

        expect(error).to have_key(:code)
        expect(error[:code]).to eq(404)
      end
    end
  end
end
