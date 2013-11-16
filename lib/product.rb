class Product
  attr_accessor :product_id, :name, :vendor_id

  def initialize(array)
    @product_id = array[0].to_i
    @name = array[1]
    @vendor_id = array[2].to_i
  end
  #rspec method
  def id
    product_id.to_i
  end

  def self.all
    @all_products ||= CSV.read("./support/products.csv").map { |array| Product.new(array) }
  end

  def self.find(product_id)
    all.find { |products| products.product_id.to_i == product_id.to_i }
  end

  def self.by_vendor(vendor_id)
    all.find_all { |products| products.vendor_id.to_i == vendor_id.to_i }
  end

  def self.find_all_by_name(name)
    all.find_all { |products| products.name.downcase.include? name.downcase }
  end

  def self.random
    find(rand(0..8193))
  end

  #returns the products that took in the most revenue
  def self.most_revenue(n)
    top_products = Sale.best_product(n)
    top_prods = top_products.collect {|pairs| find(pairs[0]).name}
    rev = top_products.collect {|pairs| (pairs[1].to_f / 100) }
    puts "The products by the most revenue are #{top_prods.join(" and ")}. The revenue obtained by each of them respectively is $#{rev.join(", $")}" 
    return top_products
  end
  #end of class methods


  #best day in revenue for this product
  def best_day 
    best = {}
    Sale.find_all_by_product(product_id).each do |sales|
      sales.purchase_time = sales.purchase_time.to_date
      if best.include? sales.purchase_time
        best[sales.purchase_time] += 1
      else
        best[sales.purchase_time] = 1
      end
    end
    puts "The best sale day for #{name.downcase} was #{best.key(best.values.max)}. It sold #{best.values.max} times."
    return best.key(best.values.max)
  end
    

  def vendor
    Vendor.find(vendor_id)
  end

  def sales
    Sale.find_all_by_product(product_id)
  end

  def number_of_sales
    sales.count
    puts "This product has been sold #{sales.count} times."
  end


end