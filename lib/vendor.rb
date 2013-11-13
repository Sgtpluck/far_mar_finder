class Vendor
  attr_accessor :vendor_id, :name, :number_of_employees, :market_id

  def initialize(array)
    @vendor_id = array[0].to_i
    @name = array[1]
    @number_of_employees = array[2].to_i
    @market_id = array[3].to_i
  end

   #these definitions are to make rspec work
  def id
    vendor_id
  end

  def no_of_employees
    number_of_employees
  end


  def day
    Time.new(purchase_time)
  end
  #end definitions for rspec

  def self.all
    @all_vendors ||= CSV.read("./support/vendors.csv").map do |array|
      Vendor.new(array)
    end
  end

  def self.find(id)
    all.find do |vendor|
      vendor.vendor_id.to_i == id.to_i
    end
  end

  #Do not need a find_all method when searching for vendor_id, since each vendor_id is unique.
  # def self.find_all_by_vendor(id)
  #   all.find_all do |vendor|
  #     vendor.vendor_id.to_i == id.to_i
  #   end
  # end

   def self.find_by_market(market_id)
    all.find_all do |vendor|
      vendor.market_id.to_i == market_id.to_i
    end
  end

  def self.by_market(market_id)
    self.find_by_market(market_id)
  end
    
  def self.find_by_number_employees(employees)
    all.find do |vendor|
      vendor.number_of_employees.to_i == employees.to_i
    end
  end

  def self.find_all_by_name(name)
    all.find_all do |vendor|
      vendor.name.downcase.include? name.downcase
    end
  end

  def market
    Market.find(market_id)
  end

  def products
    Product.by_vendor(vendor_id)
  end

  def sales
    Sale.find_by_vendor_id(vendor_id)
  end

  def sales_by_market
    Sale.find_by_market_id(market_id)
  end

  def revenue
    sum = 0
    b = Sale.all.collect do |sales|
      sales.amount_cents
    end
    b.each do |cents|
      sum += cents.to_i
    end
    return sum
  end

end