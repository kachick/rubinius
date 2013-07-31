# -*- encoding: us-ascii -*-

require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "2.0" do
  describe "Enumerator::Lazy#take" do
    before(:each) do
      @lazy = EnumeratorLazySpecs::MixedYieldAndRaiseError.new.to_enum.lazy
      ScratchPad.record []
    end

    after(:each) do
      ScratchPad.clear
    end

    it "returns new instance of Enumerator::Lazy" do
      ret = @lazy.take(1)
      ret.should be_an_instance_of(enumerator_class::Lazy)
      ret.should_not equal(@lazy)
    end

    it "sets given count to size if the given count is less than old size" do
      enumerator_class::Lazy.new(Object.new, 100) {}.take(20).size.should == 20
      enumerator_class::Lazy.new(Object.new, 100) {}.take(200).size.should == 100
    end

    it "calls the block only specified times" do
      @lazy.take(8).force.should == [0, 1, 2, 3, nil, nil, :default_arg, nil]
      ScratchPad.recorded == []
    end

    it "ignores an exception when the exception raised after yields" do
      @lazy.take(9).force.should == [0, 1, 2, 3, nil, nil, :default_arg, nil, [:multiple_yield1, :multiple_yield2]]
      ScratchPad.recorded == [:after_yields]
    end

    describe "on a nested Lazy" do
      it "sets given count to size if the given count is less than old size" do
        enumerator_class::Lazy.new(Object.new, 100) {}.take(20).take(50).size.should == 20
        enumerator_class::Lazy.new(Object.new, 100) {}.take(50).take(20).size.should == 20
      end

      it "calls the block only specified times" do
        @lazy.take(100).take(4).force.should == [0, 1, 2, 3]
      end
    end
  end
end
