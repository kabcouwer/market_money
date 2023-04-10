class MarketVendorSerializer
  include JSONAPI::Serializer
  attributes :market, :vendor
end
