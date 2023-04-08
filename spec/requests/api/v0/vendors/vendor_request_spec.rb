require 'rails_helper'

describe 'Vendor API' do
    describe 'happy paths' do
        it 'gets one vendor' do
            vendor1 = create(:vendor)

            get "/api/v0/vendors/#{vendor1.id}"

            expect(response).to be_successful

            body = JSON.parse(response.body, symbolize_names: true)
            vendor = body[:data]

            expect(vendor).to have_key(:id)
            expect(vendor[:id]).to be_a(String)
            expect(vendor[:id]).to eq(vendor1.id.to_s)

            expect(vendor).to have_key(:type)
            expect(vendor[:type]).to eq('vendor')

            expect(vendor).to have_key(:attributes)
            expect(vendor[:attributes].count).to eq(5)

            expect(vendor[:attributes][:name]).to eq(vendor1.name)
            expect(vendor[:attributes][:description]).to eq(vendor1.description)
            expect(vendor[:attributes][:contact_name]).to eq(vendor1.contact_name)
            expect(vendor[:attributes][:contact_phone]).to eq(vendor1.contact_phone)
            expect(vendor[:attributes][:credit_accepted]).to eq(vendor1.credit_accepted)
        end
    end

    describe 'sad paths' do
        it 'returns 404 with bad market id' do
            id = 12345

            get "/api/v0/vendors/#{id}"

            response = JSON.parse(body, symbolize_names: true)

            expect(response).to have_key(:errors)
            expect(response[:errors]).to be_an(Array)
            expect(response[:errors].count).to eq(1)

            message = response[:errors].first

            expect(message).to have_key(:status)
            expect(message[:status]).to eq("NOT FOUND")

            expect(message).to have_key(:message)
            expect(message[:message]).to eq("Couldn't find Vendor with 'id'=12345")

            expect(message).to have_key(:code)
            expect(message[:code]).to eq(404)
        end
    end
end