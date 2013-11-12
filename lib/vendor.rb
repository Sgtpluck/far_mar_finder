class Vendor
  attr_accessor :vendor_id, :name, :number_of_employees, :market_id

  def initialize(array)
    @vendor_id = array[0]
    @name = array[1]
    @number_of_employees = array[2]
    @market_id = array[3]
  end

  def self.all
    CSV.read("./support/vendors.csv").map do |array|
      Vendor.new(array)
    end
  end

  def self.find(id)
    all.find do |vendor|
      vendor.vendor_id.to_i == id.to_i
    end
  end

   def self.find_by_market(market_id)
    all.find_all do |vendor|
      vendor.market_id.to_i == market_id.to_i
    end
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
    Market.find_by_market_id(market_id)
  end

  def products
    Product.find_by_vendor_id(vendor_id)
  end

  def sales_by_vendor
    Sale.find_by_vendor_id(vendor_id)
  end

  def sales
    Sale.find_by_market_id(market_id)
  end

  def revenue
    sum = sales[1].inject(:+)
    puts sum
  end

end