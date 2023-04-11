class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  validates :market, presence: true
  validates :vendor, presence: true
  validate :uniqueness, on: :create

  protected

  def uniqueness
    return unless MarketVendor.find_by(market_id:, vendor_id:)

    errors.add(:base,
               "Market vendor asociation between market with market_id=#{market_id} "\
               "and vendor with vendor_id=#{vendor_id} already exists")
  end
end
