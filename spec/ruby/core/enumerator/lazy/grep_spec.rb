# -*- encoding: us-ascii -*-

require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "2.0" do
  describe "Enumerator::Lazy#grep" do
    before(:each) do
      @lazy = EnumeratorLazySpecs::MixedYieldAndRaiseError.new.to_enum.lazy
      @integer_or_array = lambda { |v| v.kind_of?(Integer) || v.kind_of?(Array) }
      ScratchPad.record []
    end

    after(:each) do
      ScratchPad.clear
    end

    it "requires an argument" do
      enumerator_class::Lazy.instance_method(:grep).arity.should == 1
    end

    it "returns new instance of Enumerator::Lazy" do
      ret = @lazy.grep(Object) {}
      ret.should be_an_instance_of(enumerator_class::Lazy)
      ret.should_not equal(@lazy)

      ret = @lazy.grep(Object)
      ret.should be_an_instance_of(enumerator_class::Lazy)
      ret.should_not equal(@lazy)
    end

    it "sets nil to size" do
      enumerator_class::Lazy.new(Object.new, 100) {}.grep(Object) {}.size.should == nil
      enumerator_class::Lazy.new(Object.new, 100) {}.grep(Object).size.should == nil
    end

    it "selects elements when the argument.===(element) returned truthy" do
      (0..Float::INFINITY).lazy.grep(Integer).first(3).should == [0, 1, 2]
      ("0".."3").lazy.grep(Integer).force.should == []
    end

    it "selects elements when the argument.===(element) returned truthy when given a block" do
      (0..Float::INFINITY).lazy.grep(Integer, &:succ).first(3).should == [1, 2, 3]
      ("0".."3").lazy.grep(Integer, &:to_i).force.should == []
    end

    describe "on a nested Lazy" do
      it "sets nil to size" do
        enumerator_class::Lazy.new(Object.new, 100) {}.grep(Object) {}.size.should == nil
        enumerator_class::Lazy.new(Object.new, 100) {}.grep(Object).size.should == nil
      end

      it "selects elements when the argument.===(element) returned truthy" do
        @lazy.take(9).grep(@integer_or_array).force.should == [0, 1, 2, 3, [:multiple_yield1, :multiple_yield2]]
        ScratchPad.recorded == [:after_yields]
      end

      it "selects elements when the argument.===(element) returned truthy when given a block" do
        @lazy.take(9).grep(@integer_or_array) {|v|v.kind_of?(Integer) ? v.succ : v }.force.should == [1, 2, 3, 4, [:multiple_yield1, :multiple_yield2]]
        ScratchPad.recorded == [:after_yields]
      end
    end
  end
end
