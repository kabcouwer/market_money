class MarketFacade
  def self.find_with_id(id)
    Market.find(id)
  rescue ActiveRecord::RecordNotFound
    Error.new("Couldn't find Market with 'id'= #{id}", "NOT FOUND", 404)
  end
end
