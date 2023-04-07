class Market < ApplicationRecord
  has_many :market_vendors, dependent: :destroy
  has_many :vendors, through: :market_vendors

  validates :name, presence: true
  validates :street, presence: true
  validates :city, presence: true
  validates :county, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :lat, presence: true
  validates :lat, numericality: { on: :create }
  validates :lon, presence: true
  validates :lon, numericality: { on: :create }

  def vendor_count
    vendors.count
  end
end
