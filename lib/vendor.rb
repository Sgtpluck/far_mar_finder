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

  def self.by_market(market_id) #this method implemented to make rspec pass
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

  def self.random
    find(rand(0..2690))
  end

  def self.preferred_vendor
    best_revenue(1)
  end

  def self.returning_market_ids(name)
    find_all_by_name(name).collect do |vendors|
      vendors.market_id
    end
  end

  def self.best_revenue(n)
    top_n_vendors = Sale.best_sales(n)
    vend = top_n_vendors.collect {|vendor_pairs| find(vendor_pairs[0]).name}
    rev = top_n_vendors.collect {|vendor_pairs| vendor_pairs[1] / 100}
    if n == 1
      puts "The best vendor is #{vend.join("")}."
    else
      puts "The top #{n} vendors are #{vend.join(" and ")}. They made, respectively, $#{rev.join(" and $")}"
    end

    return top_n_vendors
  end

  def self.least_revenue(n)
    worst_n_vendors = Sale.worst_sales(n)
    vend = worst_n_vendors.collect {|vendor_pairs| find(vendor_pairs[0]).name}
    rev = worst_n_vendors.collect {|vendor_pairs| vendor_pairs[1] / 100}
    if n != 1
      puts "The worst #{n} vendors are #{vend.join(" and ")}. They made, respectively, $#{rev.join(" and $")}"
    end
    return worst_n_vendors
  end


  #end of class methods

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

  def preferred_vendor_by_date(date)
  end

end