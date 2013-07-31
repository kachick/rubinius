# -*- encoding: us-ascii -*-

require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "2.0" do
  describe "Enumerator::Lazy#force" do
    before(:each) do
      @lazy = EnumeratorLazySpecs::MixedYieldAndRaiseError.new.to_enum.lazy
      ScratchPad.record []
    end

    after(:each) do
      ScratchPad.clear
    end

    it "calls all block and returns an Array" do
      @lazy.take(9).force(:arg1, :arg2, :arg3).should == [0, 1, 2, 3, nil, nil, :arg1, [:arg2, :arg3], [:multiple_yield1, :multiple_yield2]]
      ScratchPad.recorded == [:after_yields]
      [1, 2].lazy.map(&:succ).force.should == [2, 3]
    end

    it "passes given arguments to receiver.each" do
      @lazy.take(8).force(:arg1, :arg2, :arg3).should == [0, 1, 2, 3, nil, nil, :arg1, [:arg2, :arg3]]
      ScratchPad.recorded == []
    end

    describe "on a nested Lazy" do
      it "calls all block and returns an Array" do
        @lazy.take(4).map(&:succ).force.should == [1, 2, 3, 4]
        ScratchPad.recorded == [:after_yields]
        [1, 2].lazy.map(&:succ).map(&:succ).force.should == [3, 4]
      end
    end
  end
end
