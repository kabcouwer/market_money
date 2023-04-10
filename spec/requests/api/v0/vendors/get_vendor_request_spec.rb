require "rails_helper"

RSpec.describe "Vendors API" do
  describe "GET #show" do
    context "happy paths" do
      it "gets one vendor" do
        vendor1 = create(:vendor)

        get "/api/v0/vendors/#{vendor1.id}"

        expect(response.status).to eq(200)

        body = JSON.parse(response.body, symbolize_names: true)
        vendor = body[:data]

        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_a(String)
        expect(vendor[:id]).to eq(vendor1.id.to_s)

        expect(vendor).to have_key(:type)
        expect(vendor[:type]).to eq("vendor")

        expect(vendor).to have_key(:attributes)
        expect(vendor[:attributes].count).to eq(5)

        expect(vendor[:attributes][:name]).to eq(vendor1.name)
        expect(vendor[:attributes][:description]).to eq(vendor1.description)
        expect(vendor[:attributes][:contact_name]).to eq(vendor1.contact_name)
        expect(vendor[:attributes][:contact_phone]).to eq(vendor1.contact_phone)
        expect(vendor[:attributes][:credit_accepted]).to eq(vendor1.credit_accepted)
      end
    end

    context "sad paths" do
      it "returns 404 with bad market id" do
        id = 12_345

        get "/api/v0/vendors/#{id}"

        expect(response.status).to eq(404)

        body = JSON.parse(response.body, symbolize_names: true)
        error = body[:errors].first

        expect(error).to have_key(:status)
        expect(error[:status]).to eq("NOT FOUND")

        expect(error).to have_key(:detail)
        expect(error[:detail]).to eq("Couldn't find Vendor with 'id'=12345")

        expect(error).to have_key(:code)
        expect(error[:code]).to eq(404)
      end
    end
  end
end
