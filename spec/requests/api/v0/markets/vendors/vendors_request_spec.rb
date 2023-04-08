require 'rails_helper'

RSpec.describe 'Vendors API' do
    describe 'happy paths' do
        it 'gets all vendors for a market' do
            market1 = create(:market)
            market2 = create(:market)

            vendor1 = create(:vendor)
            vendor2 = create(:vendor)
            vendor3 = create(:vendor)

            market_vendor1 = MarketVendor.create(market_id: market1.id, vendor_id: vendor1.id)
            market_vendor2 = MarketVendor.create(market_id: market1.id, vendor_id: vendor2.id)
            market_vendor3 = MarketVendor.create(market_id: market2.id, vendor_id: vendor3.id)

            get "/api/v0/markets/#{market1.id}/vendors"

            expect(response).to be_successful

            body = JSON.parse(response.body, symbolize_names: true)
            vendors = body[:data]

            expect(vendors.count).to eq(2)

            vendors.each do |vendor|
                expect(vendor).to have_key(:id)
                expect(vendor[:id]).to be_a(String)
                expect(vendor[:id].to_i).to be_an(Integer)

                expect(vendor).to have_key(:type)
                expect(vendor[:type]).to eq('vendor')

                expect(vendor).to have_key(:attributes)
                expect(vendor[:attributes]).to be_a(Hash)
                expect(vendor[:attributes].count).to eq(5)

                expect(vendor[:attributes]).to have_key(:name)
                expect(vendor[:attributes][:name]).to be_a(String)
                expect(vendor[:attributes]).to have_key(:description)
                expect(vendor[:attributes][:description]).to be_a(String)
                expect(vendor[:attributes]).to have_key(:contact_name)
                expect(vendor[:attributes][:contact_name]).to be_a(String)
                expect(vendor[:attributes]).to have_key(:contact_phone)
                expect(vendor[:attributes][:contact_phone]).to be_a(String)
                expect(vendor[:attributes]).to have_key(:credit_accepted)
                expect(vendor[:attributes][:credit_accepted]).to be_in([true, false])
            end
        end
    end

    describe 'sad paths' do
        it 'returns 404 with bad market id' do
            id = 12345

            get "/api/v0/markets/#{id}/vendors"

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
