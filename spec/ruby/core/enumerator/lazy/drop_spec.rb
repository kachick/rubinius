# -*- encoding: us-ascii -*-

require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "2.0" do
  describe "Enumerator::Lazy#drop" do
    before(:each) do
      @lazy = EnumeratorLazySpecs::MixedYieldAndRaiseError.new.to_enum.lazy
      ScratchPad.record []
    end

    after(:each) do
      ScratchPad.clear
    end

    it "returns new instance of Enumerator::Lazy" do
      ret = @lazy.drop(1)
      ret.should be_an_instance_of(enumerator_class::Lazy)
      ret.should_not equal(@lazy)
    end

    it "sets difference of given count with old size to new size" do
      enumerator_class::Lazy.new(Object.new, 100) {}.drop(20).size.should == 80
      enumerator_class::Lazy.new(Object.new, 100) {}.drop(200).size.should == 0
    end

    it "passes blocks only specified times" do
      @lazy.drop(3).take(6).force.should == [3, nil, nil, :default_arg, nil, [:multiple_yield1, :multiple_yield2]]
      ScratchPad.recorded == [:after_yields]
    end

    describe "on a nested Lazy" do
      it "sets difference of given count with old size to new size" do
        enumerator_class::Lazy.new(Object.new, 100) {}.drop(20).drop(50).size.should == 30
        enumerator_class::Lazy.new(Object.new, 100) {}.drop(50).drop(20).size.should == 30
      end

      it "passes blocks only specified times" do
        @lazy.drop(1).drop(2).take(6).force.should == [3, nil, nil, :default_arg, nil, [:multiple_yield1, :multiple_yield2]]
        ScratchPad.recorded == [:after_yields]
      end
    end
  end
end
