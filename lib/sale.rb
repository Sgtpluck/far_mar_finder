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


  def self.all
    @all_sales ||= CSV.read("./support/sales.csv").map do |array|
    Sale.new(array)
    end
  end

  def self.find(sale_id)
    all.find do |sale|
      sale.sale_id.to_i == sale_id.to_i
    end
  end

  def self.find_by_amount_cents(amount)
    all.find do |sale|
      sale.amount_cents.to_i == amount.to_i
    end
  end

  def self.find_all_by_product(product_id)
    all.find_all do |sale|
      sale.product_id.to_i == product_id.to_i
    end
  end

  def self.find_by_vendor_id(vendor_id)
    all.find_all do |sale|
      sale.vendor_id.to_i == vendor_id.to_i
    end
  end

  def self.find_by_market_id(market_id)
    all.find_all do |sale|
      sale.market_id.to_i == market_id.to_i
    end
  end

  def self.between(beginning_time,end_time)
    all.find_all do |sale|
      (beginning_time..end_time).cover?Time.new(sale.purchase_time)
    end
  end

  def vendor
    Vendor.find(vendor_id)
  end

  def product
    Product.find(product_id)
  end

  
end