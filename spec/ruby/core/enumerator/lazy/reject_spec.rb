# -*- encoding: us-ascii -*-

require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "2.0" do
  describe "Enumerator::Lazy#reject" do
    before(:each) do
      @lazy = EnumeratorLazySpecs::MixedYieldAndRaiseError.new.to_enum.lazy
      ScratchPad.record []
    end

    after(:each) do
      ScratchPad.clear
    end

    it "returns new instance of Enumerator::Lazy" do
      ret = @lazy.reject {}
      ret.should be_an_instance_of(enumerator_class::Lazy)
      ret.should_not equal(@lazy)
    end

    it "sets nil to size" do
      enumerator_class::Lazy.new(Object.new, 100) {}.reject {}.size.should == nil
    end

    it "rejects when the given block returned truthy value" do
      @lazy.reject { |v| !v }.first(5).should == [0, 1, 2, 3, :default_arg]
      ScratchPad.recorded == [:after_yields]

      (0..Float::INFINITY).lazy.reject(&:even?).first(3).should == [1, 3, 5]
    end

    it "raises an ArgumentError when not given a block" do
      lambda { @lazy.reject }.should raise_error(ArgumentError)
    end

    describe "on a nested Lazy" do
      it "sets nil to size" do
        enumerator_class::Lazy.new(Object.new, 100) {}.take(20).reject {}.size.should == nil
      end

      it "rejects when the given block returned truthy value" do
        @lazy.take(9).reject { |v| !v }.force.should == [0, 1, 2, 3, :default_arg, [:multiple_yield1, :multiple_yield2]]
        ScratchPad.recorded == [:after_yields]
      end
    end
  end
end
