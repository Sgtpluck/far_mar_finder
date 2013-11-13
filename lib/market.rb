class Market
  attr_accessor :market_id, :name, :address, :city, :county, :state, :zip

  def initialize(array)
    @market_id = array[0].to_i
    @name = array[1]
    @address = array[2]
    @city = array[3]
    @county = array[4]
    @state = array[5]
    @zip = array[6]
  end

  def self.all #optimizing self.all with memoization
    @markets_all ||= CSV.read("./support/markets.csv").map do |array|
    Market.new(array)
  end
  end

  # def get_all
  #   CSV.read("./support/markets.csv").map do |array|
  #   Market.new(array)
  #   end
  # end

  def id #this method is just to make sure the attribute test passes
    market_id
  end

  def self.find(market_id)
    all.find do |market|
      market.market_id.to_i == market_id.to_i
    end
  end

  def self.find_by_market_id(market_id)
    all.find_all do |market|
      market.market_id.to_i == market_id.to_i
    end
  end

  def self.find_by_name(name)
    all.find do |market|
      market.name.downcase.include? name.downcase 
    end
  end

  def self.find_all_by_name(name)
    all.find_all do |market|
      market.name.downcase.include? name.downcase 
    end
  end

    def self.find_all_by_state(state)
    all.find_all do |market|
      market.state.downcase.include? state.downcase 
    end
  end

   def vendors
    Vendor.find_by_market(market_id)
   end

end