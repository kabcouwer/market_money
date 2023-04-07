require 'rails_helper'

describe 'Markets API' do
    describe 'happy paths' do
        it 'gets all markets' do
            create_list(:market, 5)

            get '/api/v0/markets'

            expect(response).to be_successful

            body = JSON.parse(response.body, symbolize_names: true)
            markets = body[:data]

            expect(markets.count).to eq(5)

            markets.each do |market|
                expect(market).to have_key(:id)
                expect(market[:id]).to be_a(String)
                expect(market[:id].to_i).to be_an(Integer)

                expect(market).to have_key(:type)
                expect(market[:type]).to eq('market')

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
                expect(market[:attributes]).to have_key(:vendor_count)
                expect(market[:attributes][:vendor_count]).to be_an(Integer)
            end
        end
    end
end