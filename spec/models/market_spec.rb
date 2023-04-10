require "rails_helper"

RSpec.describe Market, type: :model do
  describe "relationships" do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:county) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:lat) }
    it { should validate_numericality_of(:lat) }
    it { should validate_presence_of(:lon) }
    it { should validate_numericality_of(:lon) }
  end

  describe "instance methods" do
    it "can count vendors" do
      market1 = create(:market)
      market2 = create(:market)
      vendor1 = create(:vendor)
      vendor2 = create(:vendor)
      vendor3 = create(:vendor)
      vendor4 = create(:vendor)
      vendor5 = create(:vendor)
      vendor6 = create(:vendor)

      market_vendor1 = MarketVendor.create(market_id: market1.id, vendor_id: vendor1.id)
      market_vendor2 = MarketVendor.create(market_id: market1.id, vendor_id: vendor2.id)
      market_vendor3 = MarketVendor.create(market_id: market1.id, vendor_id: vendor3.id)

      expect(market1.vendor_count).to eq(3)
      expect(market2.vendor_count).to eq(0)
    end
  end
end
