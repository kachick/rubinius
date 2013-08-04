# -*- encoding: us-ascii -*-

require File.expand_path('../../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)

describe :enumerator_lazy_collect_concat, :shared => true do
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

  it "flattens elements when the given block returned an array or responding to .each and .force" do
    (0..Float::INFINITY).lazy.send(@method) { |n| (n * 10).to_s }.first(6).should == %w[0 10 20 30 40 50]
    (0..Float::INFINITY).lazy.send(@method) { |n| (n * 10).to_s.chars }.first(6).should == %w[0 1 0 2 0 3]
    (0..Float::INFINITY).lazy.send(@method) { |n| (n * 10).to_s.each_char }.first(6).all? { |o| o.instance_of? Enumerator }.should be_true
    (0..Float::INFINITY).lazy.send(@method) { |n| (n * 10).to_s.each_char.lazy }.first(6).should == %w[0 1 0 2 0 3]
  end

  it "yields with first values when given a block parameter" do
    @lazy.send(@method) { |v| v }.first(9).should == [0, 1, 2, 3, nil, nil, :default_arg, nil, :multiple_yield1]
    ScratchPad.recorded == [:after_yields]
  end

  it "yields with multiple yield arguments when given a rest block parameter" do
    @lazy.send(@method) { |*args| args }.first(8).should == [0, 1, 2, 3, nil, :default_arg, :multiple_yield1, :multiple_yield2]
    ScratchPad.recorded == [:after_yields]
  end

  it "raises an ArgumentError when not given a block" do
    lambda { @lazy.send(@method) }.should raise_error(ArgumentError)
  end

  describe "on a nested Lazy" do
    it "sets nil to size" do
      enumerator_class::Lazy.new(Object.new, 100) {}.take(50) {}.send(@method) {}.size.should == nil
    end

    it "flattens elements when the given block returned an array or responding to .each and .force" do
      (0..Float::INFINITY).lazy.map {|n| n * 10 }.send(@method) { |n| n.to_s }.first(6).should == %w[0 10 20 30 40 50]
      (0..Float::INFINITY).lazy.map {|n| n * 10 }.send(@method) { |n| n.to_s.chars }.first(6).should == %w[0 1 0 2 0 3]
      (0..Float::INFINITY).lazy.map {|n| n * 10 }.send(@method) { |n| n.to_s.each_char }.first(6).all? { |o| o.instance_of? Enumerator }.should be_true
      (0..Float::INFINITY).lazy.map {|n| n * 10 }.send(@method) { |n| n.to_s.each_char.lazy }.first(6).should == %w[0 1 0 2 0 3]
    end

    it "yields with first values when given a block parameter" do
      @lazy.take(9).send(@method) { |v| v }.force.should == [0, 1, 2, 3, nil, nil, :default_arg, nil, :multiple_yield1]
      ScratchPad.recorded == [:after_yields]
    end

    it "yields with multiple yield arguments when given a rest block parameter" do
      @lazy.take(9).send(@method) { |*args| args }.force.should == [0, 1, 2, 3, nil, :default_arg, :multiple_yield1, :multiple_yield2]
      ScratchPad.recorded == [:after_yields]
    end
  end
end
