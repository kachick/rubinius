# -*- encoding: us-ascii -*-

require File.expand_path('../../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)

describe :enumerator_lazy_collect, :shared => true do
  before(:each) do
    @lazy = EnumeratorLazySpecs::MixedYieldAndRaiseError.new.to_enum.lazy
    ScratchPad.record []
  end

  after(:each) do
    ScratchPad.clear
  end

  it "returns new instance of Enumerator::Lazy" do
    ret = @lazy.send(@method) {|n|n * n}
    ret.should be_an_instance_of(enumerator_class::Lazy)
    ret.should_not equal(@lazy)
  end

  it "keeps size" do
    enumerator_class::Lazy.new(Object.new, 100) {}.send(@method) {}.size.should == 100
  end

  describe "when the returned Lazy evaluated by Enumerable#first" do
    it "calls the block only specified times" do
      @lazy.send(@method) {|n|n * n}.first(4).should == [0, 1, 4, 9]
      (0..Float::INFINITY).lazy.send(@method, &:succ).first(3).should == [1, 2, 3]
    end
  end

  describe "on a nested Lazy" do
    it "keeps size" do
      enumerator_class::Lazy.new(Object.new, 100) {}.send(@method) {}.send(@method) {}.size.should == 100
    end

    describe "when the returned Lazy evaluated by Enumerable#first" do
      it "calls the block only specified times" do
        @lazy.send(@method) {|n|n * n}.send(@method) {|n|n * n}.first(4).should == [0, 1, 16, 81]
      end
    end
  end
end
