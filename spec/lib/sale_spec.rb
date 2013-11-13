require 'spec_helper'
describe Sale do
  
  let(:finder) { FarMarFinder.new }
  
  if FarMarFinder.new.respond_to? :sales
    let(:sale_class) { finder.sales }
  else
    let(:sale_class) { Sale }
  end
  
  describe "class methods" do
    it "responds to 'all'" do
      sale_class.should respond_to :all
    end
    
    it "'all' should return" do
      sale_class.all.count.should eq 12798
    end
    
    it "responds to 'find'" do
      sale_class.should respond_to :find
    end
  end
  
  describe "attributes" do
    let(:sale) { sale_class.find(1) }
    # 1,People's Co-op Farmers Sale,30,Portland,Multnomah,Oregon,97202
    
    it "has the id 1" do
      expect(sale.id).to eq 1
    end

    it "has the amount in cents 9290" do
      expect(sale.amount).to eq 9290
    end

    it "has the day 31" do
      expect(sale.purchase_time.day).to eq 7
    end

    it "has the vendor_id 1" do
      expect(sale.vendor_id).to eq 1
    end
    
    it "has the product_id 1" do
      expect(sale.product_id).to eq 1
    end
    
  end
  
  describe "instance methods" do
    let(:sale) { sale_class.find(1) }
    it "responds to vendor" do
      sale.should respond_to :vendor
    end
    
    it "has the vendor" do
      sale.vendor.id.should eq sale.vendor_id
    end
    it "responds to product" do
      sale.should respond_to :product
    end
    it "has the product" do
      sale.product.id.should eq sale.product_id
    end
    
  end
end
