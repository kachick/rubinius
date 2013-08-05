# -*- encoding: us-ascii -*-

require File.expand_path('../../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

ruby_version_is "2.0" do
  describe "Enumerator::Lazy#zip" do
    before(:each) do
      @lazy = EnumeratorLazySpecs::MixedYieldAndRaiseError.new.to_enum.lazy
      ScratchPad.record []
    end

    after(:each) do
      ScratchPad.clear
    end

    it "requires multiple arguments" do
      enumerator_class::Lazy.instance_method(:zip).arity.should < 0
    end

    it "returns new instance of Enumerator::Lazy" do
      ret = @lazy.zip []
      ret.should be_an_instance_of(enumerator_class::Lazy)
      ret.should_not equal(@lazy)
    end

    it "calls the block with a gathered array from self and arguments" do
      (0..Float::INFINITY).lazy.zip([20, 30], [40, 50]).first(3).should == [[0, 20, 40], [1, 30, 50], [2, nil, nil]]
    end

    it "keeps size" do
      enumerator_class::Lazy.new(Object.new, 100) {}.zip([], []).size.should == 100
    end

    it "calls the block with an array that gathered from initial yielded args and arguments" do
      @lazy.zip(EnumeratorLazySpecs::MixedYieldAndRaiseError.new.to_enum).first(9).should == [
        [0, 0],
        [1, 1],
        [2, 2],
        [3, 3],
        [nil, nil],
        [false, nil],
        [:default_arg, :default_arg],
        [false, nil],
        [:multiple_yield1, [:multiple_yield1, :multiple_yield2]]
      ]

      ScratchPad.recorded.should == []
    end

    it "returns a Lazy when no arguments given" do
      @lazy.zip.should be_an_instance_of(enumerator_class::Lazy)
    end

    it "raises a TypeError if arguments contain non-list object" do
      lambda { @lazy.zip [], Object.new, [] }.should raise_error(TypeError)
    end

    describe "on a nested Lazy" do
      it "calls the block with a gathered array from self and arguments" do
        ret = (0..Float::INFINITY).lazy.take(3).zip([20, 30], [40, 50]).force.should == [[0, 20, 40], [1, 30, 50], [2, nil, nil]]
      end

      it "keeps size" do
        enumerator_class::Lazy.new(Object.new, 100) {}.map {}.zip([], []).size.should == 100
      end

      it "evaluates immediately when given a block" do
        yields = []
        @lazy.take(2).zip([10, 20], [:a]) { |*lists| yields << lists }
        yields.should == [[[0, 10, :a]], [[1, 20, nil]]]
      end
    end
  end
end
