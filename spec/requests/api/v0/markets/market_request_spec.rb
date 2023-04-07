require 'rails_helper'

describe 'Market API' do
    describe 'happy paths' do
        it 'gets one market' do
            market1 = create(:market)
            vendor1 = create(:vendor)
            vendor2 = create(:vendor)
            vendor3 = create(:vendor)
            market_vendor1 = MarketVendor.create(market_id: market1.id, vendor_id: vendor1.id)
            market_vendor2 = MarketVendor.create(market_id: market1.id, vendor_id: vendor2.id)
            market_vendor3 = MarketVendor.create(market_id: market1.id, vendor_id: vendor3.id)

            get "/api/v0/markets/#{market1.id}"

            expect(response).to be_successful

            body = JSON.parse(response.body, symbolize_names: true)
            market = body[:data]

            expect(market).to have_key(:id)
            expect(market[:id]).to be_a(String)
            expect(market[:id]).to eq(market1.id.to_s)

            expect(market).to have_key(:type)
            expect(market[:type]).to eq('market')

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

    describe 'sad paths' do
        it 'returns 404 with bad market id' do
            id = 12345

            get "/api/v0/markets/#{id}"

            response = JSON.parse(body, symbolize_names: true)

            expect(response).to have_key(:errors)
            expect(response[:errors]).to be_an(Array)
            expect(response[:errors].count).to eq(1)

            message = response[:errors].first

            expect(message).to have_key(:status)
            expect(message[:status]).to eq("NOT FOUND")

            expect(message).to have_key(:message)
            expect(message[:message]).to eq("Couldn't find Market with 'id'=12345")

            expect(message).to have_key(:code)
            expect(message[:code]).to eq(404)
        end
    end
end