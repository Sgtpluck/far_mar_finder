require 'spec_helper'

describe Product do
  
  let(:finder) { FarMarFinder.new }
  
  if FarMarFinder.new.respond_to? :products
    let(:product_class) { finder.products }
  else
    let(:product_class) { Product }
  end
  
  describe "class methods" do
    it "responds to 'all'" do
      product_class.should respond_to :all
    end
    
    it "'all' should return" do
      product_class.all.count.should eq 8193
    end
    
    it "responds to 'find'" do
      product_class.should respond_to :find
    end
    
    it "responds to 'by_vendor'" do
      product_class.should respond_to :by_vendor
    end
    
    it "find the first product by market 1" do
      product_class.by_vendor(1).first.name.should eq "Dry Beets"
    end
  end
  
  describe "attributes" do
    let(:product) { product_class.find(10) }
    # 10,Kertzmann LLC,11,3
    
    it "has the id 10" do
      product.id.should eq 10
    end
    
    it "has the name" do
      product.name.should eq "Black Apples"
    end
    
    it "has the vendor id 5" do
      product.vendor_id.should eq 5
    end
  end
  
  describe "associations" do
    let(:product) { product_class.find(62) }

    it "responds to :market" do
      product.should respond_to :vendor
    end
    
    it "market_id matches the markets id" do
      product.vendor.id.should eq product.vendor_id
    end
    
    it "responds to :sales" do
      product.should respond_to :sales
    end
    
    it "has 1 sales" do
      product.sales.count.should eq 2
    end
    
  end
  
end