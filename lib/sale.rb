class Sale
  attr_accessor :sale_id, :amount_cents, :purchase_time, :vendor_id, :product_id

  def initialize(array)
    @sale_id = array[0]
    @amount_cents = array[1].to_i
    @purchase_time = Time.parse(array[2])
    @vendor_id = array[3].to_i
    @product_id = array[4].to_i
  end

  #these definitions are to make rspec work
  def id
    sale_id.to_i
  end

  def amount
    amount_cents
  end
  #end definitions for rspec

  #class methods
  def self.all
    @all_sales ||= CSV.read("./support/sales.csv").map {|array| Sale.new(array) }
  end

  def self.find(sale_id)
    all.find { |sale| sale.sale_id.to_i == sale_id.to_i }
  end

  def self.find_by_amount_cents(amount)
    all.find { |sale| sale.amount_cents.to_i == amount.to_i }
  end

  def self.find_all_by_product(product_id)
    all.find_all { |sale| sale.product_id.to_i == product_id.to_i }
  end

  def self.find_by_vendor_id(vendor_id)
    all.find_all { |sale| sale.vendor_id.to_i == vendor_id.to_i }
  end

  def self.find_by_date(purchase_time)
    all.find_all do |sale|
      sale.purchase_time.yday == set_time(purchase_time).yday
    end
  end

  def self.find_by_market_id(market_id)
    all.find_all { |sale| sale.market_id.to_i == market_id.to_i }
  end

  def self.between(beginning_time, end_time)
    all.find_all { |sale| set_time(beginning_time) < sale.purchase_time && sale.purchase_time < set_time(end_time) }
  end

  def self.sort_sales
    @best ||= all.each { |sales| sales.amount_cents}
  end

  def self.random
    find(rand(0..12001))
  end

   def self.revenue_by_product
    @product_revenue ||= @by  = {}
    all.each do |sales|
      if @product_revenue.include? sales.product_id
        @product_revenue[sales.product_id]+= sales.amount_cents
      elsif
        @product_revenue[sales.product_id] = sales.amount_cents
      end
    end
    @product_revenue.sort_by {|id, revenue|revenue/100}
  end

  def self.best_product(n)
    revenue_by_product.last(n).reverse
  end

  def self.revenue_by_vendor
    @vendor_revenue ||= @vendor_revenue = {}
    all.each do |sales|
      if @vendor_revenue.include? sales.vendor_id
        @vendor_revenue[sales.vendor_id]+=(sales.amount_cents)
      else
        @vendor_revenue[sales.vendor_id] = sales.amount_cents
      end
    end
    @vendor_revenue.sort_by {|id, revenue|revenue/100}
  end

  def self.sales_by_vendor
    @vendor_sales ||= @vendor_sales = {}
    all.each do |sales|
      if @vendor_sales.include? sales.vendor_id
        @vendor_sales[sales.vendor_id]+=1
      else
        @vendor_sales[sales.vendor_id]=1
      end
    end
    @vendor_sales.sort_by {|id,num|num}
  end

  def self.best_sales(n)
    sales_by_vendor.last(n).reverse
  end
        

  def self.worst_sales(n)
     revenue_by_vendor.first(n)
  end

  def self.best_sales(n)
    revenue_by_vendor.last(n).reverse
  end

  def self.between(beginning_time,end_time)
    all.find_all { |sale| (beginning_time.yday..end_time.yday).include? sale.purchase_time.yday }
  end


  def self.best_day
    date_hash = {}
    all.each do |sale|
      sale.purchase_time = set_time(sale.purchase_time)
      if date_hash.include? sale.purchase_time
        date_hash[sale.purchase_time] += 1
      else
        date_hash[sale.purchase_time] = 1
      end
    end
    puts "The best day in terms of sales was #{date_hash.key(date_hash.values.max)}, when there were #{date_hash.values.max} sales."
    return date_hash.values.max
  end

  #end of class methods

  def vendor
    Vendor.find(vendor_id)
  end

  def product
    Product.find(product_id)
  end

private
    #helper function for time
  def self.set_time(time)
    if time.is_a? String
      time.to_date
    else
     time
    end
  end


end