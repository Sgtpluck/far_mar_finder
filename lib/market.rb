class Market
  attr_accessor :market_id, :name, :address, :city, :county, :state, :zip

  def initialize(array)
    @market_id = array[0]
    @name = array[1]
    @address = array[2]
    @city = array[3]
    @county = array[4]
    @state = array[5]
    @zip = array[6]
  end

  def self.all
    @all_markets ||= CSV.read("./support/markets.csv").map { |array| Market.new(array) }
  end

  def id
    market_id.to_i
  end

  def self.find(market_id)
    all.find { |market| market.market_id.to_i == market_id.to_i }
  end

  def self.find_by_market_id(market_id)
    all.find_all { |market| market.market_id.to_i == market_id.to_i }
  end

  def self.find_by_name(name)
    all.find { |market| market.name.downcase.include? name.downcase }
  end

  def self.find_all_by_name(name)
    all.find_all { |market| market.name.downcase.include? name.downcase }
  end

    def self.find_all_by_state(state)
    all.find_all { |market| market.state.downcase.include? state.downcase }
  end

  def self.random
    find(rand(0..500))
  end

  def self.search(search_term)
    markets_with_vendor = []
    Vendor.returning_market_ids(search_term).collect do |ids| 
      find_by_market_id(ids).collect do |markets|
       if markets_with_vendor.include? markets.name
        else
          markets_with_vendor.push(markets.name) 
        end
      end
    end
    found_markets = find_all_by_name(search_term).collect { |markets| markets.name }
    puts "These are the markets with that name: #{found_markets.join(" and ")}" if !found_markets.empty?
    puts "These are the markets that have a vendor with that name: #{markets_with_vendor.join(" and ")}" if !markets_with_vendor.empty?
  end

  def vendors
    Vendor.find_by_market(market_id)
  end

  #returns a collection of product instances associated through the vendor
  def products
    prod = vendors.map(&:products).flatten.map(&:name)
    puts "#{@name} sells #{prod.length} products. They are #{prod.join(" and ").downcase}."
    prod
  end

end