class Product
  attr_accessor :product_id, :name, :vendor_id

  def initialize(array)
    @product_id = array[0].to_i
    @name = array[1]
    @vendor_id = array[2].to_i
  end

  def id
    product_id.to_i
  end

  def self.all
    @all_products ||= CSV.read("./support/products.csv").map do |array|
      Product.new(array)
      end
  end

  def self.find(product_id)
    all.find do |products|
      products.product_id.to_i == product_id.to_i
    end
  end

  def self.by_vendor(vendor_id)
    all.find_all do |products|
      products.vendor_id.to_i == vendor_id.to_i
    end
  end

  def self.find_all_by_name(name)
    all.find_all do |products|
      products.name.downcase.include? name.downcase
    end
  end

  def self.random
    find(rand(0..8193))
  end

  def best_day #best day in revenue for this product
    best = {}
    Sale.find_all_by_product(product_id).each do |sales|
      sales.purchase_time = sales.purchase_time.to_s[0..9]
      if best.include? sales.purchase_time
        best[sales.purchase_time] += sales.amount_cents
      else
        best[sales.purchase_time] = sales.amount_cents
      end
    end
    puts "The best sale day for #{name.downcase} was #{best.key(best.values.max)}. Its revenue for that day was #{best.values.max}"
    return best.key(best.values.max)
  end
    

  def vendor
    Vendor.find(vendor_id)
  end

  def sales
    Sale.find_all_by_product(product_id)
  end

  def number_of_sales
    sales.length
  end

  def number_of_sales
    sales.count
    puts "This product has been sold #{sales.count} times."
  end


end