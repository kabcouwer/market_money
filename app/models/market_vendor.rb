class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  validates :market_id, presence: true
  validates :market, presence: true
  validates :vendor_id, presence: true
  validates :vendor, presence: true
end
