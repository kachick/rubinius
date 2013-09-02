# -*- encoding: us-ascii -*-

require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "2.0" do
  describe "Range#size" do
    describe "with Integer elements" do
      it "returns difference between beginning number and ending number" do
        (1..3).size.should == 3
        (1...3).size.should == 2
      end
    end

    describe "with ending Float::INFINITY" do
      it "returns Float::INFINITY" do
        (1..Float::INFINITY).size.should == Float::INFINITY
        (1...Float::INFINITY).size.should == Float::INFINITY
      end

      it "returns 0 if beginning with Float::INFINITY" do
        (Float::INFINITY..Float::INFINITY).size.should == 0
        (Float::INFINITY...Float::INFINITY).size.should == 0
      end
    end

    describe "wiht other Numeric elements" do
      it "returns an Integer coerced difference between beginning number and ending number" do
        (1.1..3.9).size.should == 3
        (1.1...3.9).size.should == 3
      end
    end

    describe "wiht non Numeric elements" do
      it "returns nil" do
        ("1".."3").size.should be_nil
        ("1"..."3").size.should be_nil
      end
    end
  end
end
