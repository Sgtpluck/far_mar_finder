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
    @all_vendors ||= CSV.read("./support/vendors.csv").map {|array| Vendor.new(array) }
  end

  def self.find(id)
    all.find {|vendor| vendor.vendor_id.to_i == id.to_i }
  end

   def self.find_by_market(market_id)
    all.find_all {|vendor| vendor.market_id.to_i == market_id.to_i }
  end

  def self.by_market(market_id) #this method implemented to make rspec pass
    find_by_market(market_id)
  end
    
  def self.find_by_number_employees(employees)
    all.find { |vendor| vendor.number_of_employees.to_i == employees.to_i }
  end

  def self.find_all_by_name(name)
    all.find_all {|vendor| vendor.name.downcase.include? name.downcase }
  end

  def self.random
    find(rand(0..2690))
  end

  def self.preferred_vendor
    best_revenue(1)
  end

  def self.returning_market_ids(name)
    find_all_by_name(name).map(&:market_id)
  end

  #top n vendors in terms of revenue
  def self.most_revenue(n)
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


  #worst n vendors in terms of revenue
  def self.least_revenue(n)
    worst_n_vendors = Sale.worst_sales(n)
    vend = worst_n_vendors.collect {|vendor_pairs| find(vendor_pairs[0]).name}
    rev = worst_n_vendors.collect {|vendor_pairs| vendor_pairs[1] / 100}
    if n != 1
      puts "The worst #{n} vendors are #{vend.join(" and ")}. They made, respectively, $#{rev.join(" and $")}"
    end
    return worst_n_vendors
  end

  # top n vendors in terms of volume of sales
  def self.most_items(n) 
    vend_most = Sale.best_sales(n)
    vend = vend_most.collect {|vendor_pairs| find(vendor_pairs[0]).name}
    num_sales = vend_most.collect {|vendor_pairs| vendor_pairs[1]}
    if n == 1
      puts "The top vendor in terms of sales volume is #{vend.join}, who had #{num_sales.join} sales."
    else
    puts "The top #{n} vendors in terms of sales volume are #{vend.join(" and ")}. They have, respectively, #{num_sales.join(" and ")} sales."
      vend_most
    end
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

  def revenue(first_date=nil,second_date=nil)
    sum = 0
    if first_date == nil && second_date == nil
      Sale.find_by_vendor_id(vendor_id).collect {|sales| sales.amount_cents}.each {|cents| sum+= cents.to_i}
    elsif first_date && second_date == nil
        Sale.find_by_date(first_date).collect { |sales| sum+=sales.amount_cents if sales.vendor_id == vendor_id }
    else
      Sale.between(first_date,second_date).collect { |sales| sum+=sales.amount_cents if sales.vendor_id == vendor_id }
    end
    puts "$#{sum/100}"
  return sum
  end

end