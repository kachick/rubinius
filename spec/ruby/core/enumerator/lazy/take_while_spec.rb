# -*- encoding: us-ascii -*-

require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "2.0" do
  describe "Enumerator::Lazy#take_while" do
    before(:each) do
      @lazy = EnumeratorLazySpecs::MixedYieldAndRaiseError.new.to_enum.lazy
      ScratchPad.record []
    end

    after(:each) do
      ScratchPad.clear
    end

    it "returns new instance of Enumerator::Lazy" do
      ret = @lazy.take_while {}
      ret.should be_an_instance_of(enumerator_class::Lazy)
      ret.should_not equal(@lazy)
    end

    it "sets nil to size" do
      enumerator_class::Lazy.new(Object.new, 100) {}.take_while { true }.size.should == nil
    end

    it "takes from head to just before falsy returned" do
      @lazy.take_while { |v| v }.force.should == [0, 1, 2, 3]
      ScratchPad.recorded == []
    end

    it "raises an ArgumentError when not given a block" do
      lambda { @lazy.take_while }.should raise_error(ArgumentError)
    end

    describe "on a nested Lazy" do
      it "sets nil to size" do
        enumerator_class::Lazy.new(Object.new, 100) {}.take(20).take_while { true }.size.should == nil
      end

      it "takes from head to just before falsy returned" do
        @lazy.take(3).take_while { |v| v }.force.should == [0, 1, 2]
        ScratchPad.recorded == []
      end
    end
  end
end
