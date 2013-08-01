# -*- encoding: us-ascii -*-

require File.expand_path('../../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)

describe :enumerator_lazy_select, :shared => true do
  before(:each) do
    @lazy = EnumeratorLazySpecs::MixedYieldAndRaiseError.new.to_enum.lazy
    ScratchPad.record []
  end

  after(:each) do
    ScratchPad.clear
  end

  it "returns new instance of Enumerator::Lazy" do
    ret = @lazy.send(@method) {}
    ret.should be_an_instance_of(enumerator_class::Lazy)
    ret.should_not equal(@lazy)
  end

  it "sets nil to size" do
    enumerator_class::Lazy.new(Object.new, 100) {}.send(@method) { true }.size.should == nil
  end

  it "selects elements when the given block returned truthy value" do
    @lazy.send(@method) { |v| v }.first(5).should == [0, 1, 2, 3, :default_arg]
    ScratchPad.recorded == [:after_yields]

    (0..Float::INFINITY).lazy.send(@method, &:even?).first(3).should == [0, 2, 4]
  end

  it "raises an ArgumentError when not given a block" do
    lambda { @lazy.send(@method) }.should raise_error(ArgumentError)
  end

  describe "on a nested Lazy" do
    it "sets nil to size" do
      enumerator_class::Lazy.new(Object.new, 100) {}.take(50) {}.send(@method) { true }.size.should == nil
    end

    it "selects elements when the given block returned truthy value" do
      @lazy.take(9).send(@method) { |v| v }.force.should == [0, 1, 2, 3, :default_arg, [:multiple_yield1, :multiple_yield2]]
      ScratchPad.recorded == [:after_yields]
    end
  end
end
