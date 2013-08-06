# -*- encoding: us-ascii -*-

require File.expand_path('../../../../../spec_helper', __FILE__)
require File.expand_path('../../fixtures/classes', __FILE__)

describe :enumerator_lazy_collect, :shared => true do
  before(:each) do
    @mixedyield = EnumeratorLazySpecs::MixedYieldAndRaiseError.new.to_enum.lazy
    ScratchPad.record []
  end

  after(:each) do
    ScratchPad.clear
  end

  it "returns new instance of Enumerator::Lazy" do
    ret = @mixedyield.send(@method) {}
    ret.should be_an_instance_of(enumerator_class::Lazy)
    ret.should_not equal(@mixedyield)
  end

  it "keeps size" do
    enumerator_class::Lazy.new(Object.new, 100) {}.send(@method) {}.size.should == 100
  end

  describe "when the returned Lazy evaluated by Enumerable#first" do
    it "stops after specified times" do
      (0..Float::INFINITY).lazy.send(@method, &:succ).first(3).should == [1, 2, 3]
    end

    it "calls the block with initial yield arguments" do
      @mixedyield.send(@method) { |v| v }.first(12).should == [nil, 0, 0, 0, 0, nil, :default_arg, [], [], [0], [0, 1], [0, 1, 2]]
      ScratchPad.recorded.should == []
    end
  end

  describe "on a nested Lazy" do
    it "keeps size" do
      enumerator_class::Lazy.new(Object.new, 100) {}.send(@method) {}.send(@method) {}.size.should == 100
    end

    describe "when the returned Lazy evaluated by Enumerable#first" do
      it "stops after specified times" do
        (0..Float::INFINITY).lazy.send(@method, &:succ).send(@method, &:succ).first(3).should == [2, 3, 4]
      end
    end
  end
end
