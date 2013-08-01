# -*- encoding: us-ascii -*-

require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "2.0" do
  describe "Enumerator::Lazy#drop_while" do
    before(:each) do
      @lazy = EnumeratorLazySpecs::MixedYieldAndRaiseError.new.to_enum.lazy
      ScratchPad.record []
    end

    after(:each) do
      ScratchPad.clear
    end

    it "returns new instance of Enumerator::Lazy" do
      ret = @lazy.drop_while {}
      ret.should be_an_instance_of(enumerator_class::Lazy)
      ret.should_not equal(@lazy)
    end

    it "sets nil to size" do
      enumerator_class::Lazy.new(Object.new, 100) {}.drop_while { |v| v }.size.should == nil
    end

    it "takes from just before falsy returned to tail" do
      @lazy.drop_while { |v| v }.take(5).force.should == [nil, nil, :default_arg, nil, [:multiple_yield1, :multiple_yield2]]
      ScratchPad.recorded == [:after_yields]
    end

    it "raises an ArgumentError when not given a block" do
      lambda { @lazy.drop_while }.should raise_error(ArgumentError)
    end

    describe "on a nested Lazy" do
      it "sets nil to size" do
        enumerator_class::Lazy.new(Object.new, 100) {}.take(20).drop_while { |v| v }.size.should == nil
      end

      it "takes from just before falsy returned to tail" do
        @lazy.take(9).drop_while { |v| v }.force.should == [nil, nil, :default_arg, nil, [:multiple_yield1, :multiple_yield2]]
        ScratchPad.recorded == [:after_yields]
      end
    end
  end
end
