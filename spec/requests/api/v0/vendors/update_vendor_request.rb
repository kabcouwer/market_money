require "rails_helper"

RSpec.describe "Vendors API" do
  describe "PATCH #update" do
    context "happy paths" do
      it "updates a vendor" do
        vendor = create(:vendor)

        update_params = {
          description:     "A new description",
        }

        headers = { "CONTENT_TYPE" => "application/json" }

        patch "/api/v0/vendors/#{vendor.id}", headers:,
                                params:  JSON.generate(vendor: update_params)

        expect(response).to have_http_status(200)

        body = JSON.parse(response.body, symbolize_names: true)
        updated_vendor = body[:data]

        expect(vendor.id).to eq(updated_vendor[:id].to_i)
        expect(vendor.name).to eq(updated_vendor[:attributes][:name])
        expect(update_params[:description]).to eq(updated_vendor[:attributes][:description])
        expect(vendor.contact_name).to eq(updated_vendor[:attributes][:contact_name])
        expect(vendor.contact_phone).to eq(updated_vendor[:attributes][:contact_phone])
        expect(vendor.credit_accepted).to eq(updated_vendor[:attributes][:credit_accepted])
      end
    end

    context "sad paths" do
      it "returns not found error if vendor does not exist" do
        vendor_id = 12_345

        update_params = {
          description:     "A new description",
          contact_name:    "Updated Name",
          credit_accepted: false
        }

        headers = { "CONTENT_TYPE" => "application/json" }

        patch "/api/v0/vendors/#{vendor_id}", headers:,
                                params:  JSON.generate(vendor: update_params)

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

      it "returns bad request if any params are blank" do
        vendor = create(:vendor)

        update_params = {
          description:     "",
          credit_accepted: false
        }

        headers = { "CONTENT_TYPE" => "application/json" }

        patch "/api/v0/vendors/#{vendor.id}", headers:,
                                params:  JSON.generate(vendor: update_params)

        expect(response.status).to eq(400)

        body = JSON.parse(response.body, symbolize_names: true)
        error = body[:errors].first

        expect(error).to have_key(:status)
        expect(error[:status]).to eq("BAD REQUEST")

        expect(error).to have_key(:detail)
        expect(error[:detail]).to eq("Validation Failed: Description can't be blank")

        expect(error).to have_key(:code)
        expect(error[:code]).to eq(400)
      end
    end
  end
end
