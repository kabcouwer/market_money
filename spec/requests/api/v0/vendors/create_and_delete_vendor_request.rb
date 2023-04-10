require "rails_helper"

RSpec.describe "Vendors API" do
  describe "POST #create and DELETE #destroy" do
    context "with valid attributes" do
      it "creates and deletes a new vendor" do
        vendor_params = {
          name:            "New Vendor",
          description:     "A description",
          contact_name:    "Contact Name",
          contact_phone:   "123.456.7890",
          credit_accepted: false
        }

        headers = { "CONTENT_TYPE" => "application/json" }

        post "/api/v0/vendors", headers:,
                                params:  JSON.generate(vendor: vendor_params)

        expect(response).to have_http_status(201)

        created_vendor = Vendor.last

        expect(created_vendor.name).to eq(vendor_params[:name])
        expect(created_vendor.description).to eq(vendor_params[:description])
        expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
        expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
        expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])

        expect do
          delete "/api/v0/vendors/#{created_vendor.id}"
        end.to change(Vendor, :count).by(-1)

        expect(response.status).to eq(204)
        expect(response.body).to eq("")
      end

      it "deletes any associations with that vendor if deleted" do
        market = create(:market)
        vendor = create(:vendor)
        market_vendor = MarketVendor.create(
          market_id: market.id,
          vendor_id: vendor.id
        )

        expect(MarketVendor.all.count).to eq(1)
        expect { delete "/api/v0/vendors/#{vendor.id}" }.to change(Vendor, :count).by(-1)
        expect(MarketVendor.all.count).to eq(0)
      end
    end

    context "without valid attributes" do
      it "returns an error if any attribute is missing with new vendor post" do
        vendor_params = {
          "name":            "Buzzy Bees",
          "description":     "local honey and wax products",
          "credit_accepted": true
        }

        headers = { "CONTENT_TYPE" => "application/json" }

        post "/api/v0/vendors", headers:,
                                params:  JSON.generate(vendor: vendor_params)

        expect(response.status).to eq(400)

        body = JSON.parse(response.body, symbolize_names: true)
        error = body[:errors].first

        expect(error[:status]).to eq("BAD REQUEST")
        expect(error[:detail]).to eq("Validation Failed: Contact name can't be blank, Contact phone can't be blank")
        expect(error[:code]).to eq(400)
      end

      it "returns not found error if vendor to be deleted does not exist" do
        vendor_id = 12_345

        delete "/api/v0/vendors/#{vendor_id}"

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
