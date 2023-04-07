class MarketSerializer
  include JSONAPI::Serializer
  attributes :name, :street, :city, :county, :state, :zip, :lat, :lon, :vendor_count

  # def vendor_count
  #   require 'pry'; binding.pry
  # end
end
