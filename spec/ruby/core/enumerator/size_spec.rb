require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "2.0" do
  describe "Enumerator#size" do
    it "returns same value if set size is an Integer" do
      Enumerator.new(100) {}.size.should == 100
    end

    it "returns nil if set size is nil" do
      Enumerator.new(nil) {}.size.should be_nil
    end

    it "returns returning value from size.call if set size is a Proc" do
      base_size = 100
      enum = Enumerator.new(lambda { base_size + 1 }) {}
      base_size = 200
      enum.size.should == 201
      base_size = 300
      enum.size.should == 301
    end

    it "returns returning value from size.call without coercing" do
      coercible = mock "not coercible to an Intege"
      coercible.should_not_receive(:to_int)
      Enumerator.new(lambda { coercible }) {}.size.should equal(coercible)
    end

    ruby_version_is "2.1" do
      it "returns returning value from size.call if set size has #call method" do
        callable = mock "callable"
        callable.should_receive(:call).and_return :returned_from_call
        Enumerator.new(callable) {}.size.should == :returned_from_call
      end
    end
  end
end
