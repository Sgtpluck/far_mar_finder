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
  @all_markets ||= CSV.read("./support/markets.csv").map do |array|
    Market.new(array)
    end
  end

  def id
    market_id.to_i
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

  def self.random
    find(rand(0..500))
  end

  def vendors
    Vendor.find_by_market(market_id)
  end

   #extra credit methods

  def products
    prod = vendors.collect do |vendors|
      vendors.products.collect do |products|
        products.name
      end
    end
      puts "#{@name} sells #{prod.flatten.length} products. They are #{prod.join(" and ").downcase}."
  end

  def self.search(search_term)
    markets_with_vendor = []
    market_ids = Vendor.returning_market_ids(search_term) #finding the market IDs of the vendors with the search them
    market_ids.collect do |ids| #this is spitting back the names of the markets with the vendors that have this name
      find_by_market_id(ids).collect do |markets|
        markets.name
        if markets_with_vendor.include? markets.name #hopefully this is making sure the markets aren't doubling up
        else
          markets_with_vendor.push(markets.name) 
        end
      end
    end
    found_markets = find_all_by_name(search_term).collect do |markets|
    markets.name #this is making an array of all the markets with this name
      end

    if !found_markets.empty?
    puts "These are the markets with that name: #{found_markets.join(" and ")}"
    end
    if !markets_with_vendor.empty?
    puts "These are the markets that have a vendor with that name: #{markets_with_vendor.join(" and ")}"
    end
  end


end