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
      # puts array.inspect
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

  def vendor
    Vendor.find(vendor_id)
  end

  def sales
    Sale.find_all_by_product(product_id)
  end

  def number_of_sales
    sales.length
  end

end