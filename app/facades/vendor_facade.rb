class VendorFacade
  def self.find_with_id(id)
    @vendor = Vendor.find(id)
  rescue ActiveRecord::RecordNotFound
    Error.new("Couldn't find Vendor with 'id'= #{id}", "NOT FOUND", 404)
  end
end
