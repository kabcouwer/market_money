require "rails_helper"

RSpec.describe MarketVendor, type: :model do
  before :each do
    MarketVendor.destroy_all
    Market.destroy_all
    Vendor.destroy_all
  end

  describe "relationships" do
    it { should belong_to(:market) }
    it { should belong_to(:vendor) }
  end

  describe "validations" do
    it { should validate_presence_of(:market) }
    it { should validate_presence_of(:vendor) }
  end

  describe "validate uniqueness" do
    it "returns error if association already exists" do
      market = create(:market)
      vendor = create(:vendor)
      market_vendor = MarketVendor.new(
        market_id: market.id,
        vendor_id: vendor.id
      )

      market_vendor.save

      expect(MarketVendor.all.count).to eq(1)

      market_vendor2 = MarketVendor.new(
        market_id: market.id,
        vendor_id: vendor.id
      )
      market_vendor2.save

      expect(market_vendor2.errors.full_messages.join(", ")).to eq("Market vendor association between market with market_id=#{market.id} and vendor with vendor_id=#{vendor.id} already exists")
      expect(MarketVendor.all.count).to eq(1)
    end
  end
end
