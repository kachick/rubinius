require File.expand_path('../../../spec_helper', __FILE__)

describe :enum_new, :shared => true do
  it "creates a new custom enumerator with the given object, iterator and arguments" do
    enum = enumerator_class.new(1, :upto, 3)
    enum.should be_an_instance_of(enumerator_class)
  end

  it "creates a new custom enumerator that responds to #each" do
    enum = enumerator_class.new(1, :upto, 3)
    enum.respond_to?(:each).should == true
  end

  it "creates a new custom enumerator that runs correctly" do
    enumerator_class.new(1, :upto, 3).map{|x|x}.should == [1,2,3]
  end

  it "aliases the second argument to :each" do
    enumerator_class.new(1..2).to_a.should == enumerator_class.new(1..2, :each).to_a
  end

  it "doesn't check for the presence of the iterator method" do
    enumerator_class.new(nil).should be_an_instance_of(enumerator_class)
  end

  it "uses the latest define iterator method" do
    class StrangeEach
      def each
        yield :foo
      end
    end
    enum = enumerator_class.new(StrangeEach.new)
    enum.to_a.should == [:foo]
    class StrangeEach
      def each
        yield :bar
      end
    end
    enum.to_a.should == [:bar]
  end

  ruby_version_is "2.0" do
    describe "with size" do
      before(:each) do
        ScratchPad.record []

        @proc = Proc.new do
          ScratchPad << :called
          :returned_from_call
        end

        @callable = Object.new
        def @callable.call
          ScratchPad << :called
          :returned_from_call
        end
      end

      after(:each) do
        ScratchPad.clear
      end

      it "sets the given size to own size if the given size is an Integer" do
        enumerator_class.new(100) {}.size.should == 100
      end

      it "sets nil to own size if the given size is nil" do
        enumerator_class.new(nil) {}.size.should be_nil
      end

      it "accepts a coercible object after corecing to an Integer" do
        coercible = mock("coercible to an Integer with #to_int")
        coercible.should_receive(:to_int).and_return 100
        enumerator_class.new(coercible) {}.size.should == 100
      end

      it "accepts a Proc without calling #call in construction" do
        enum = enumerator_class.new(@proc) {}
        ScratchPad.recorded.should == []
        enum.size.should == :returned_from_call
        ScratchPad.recorded.should == [:called]
      end

      it "raises a TypeError if the given size is not a callable object" do
        lambda {
          enumerator_class.new(Object.new) {}
        }.should raise_error(TypeError)
      end

      describe "when the given size is a callable object but not a Proc" do
        ruby_version_is "" ... "2.1" do
          it "raises a TypeError without calling #call" do
            lambda {
              enumerator_class.new(@callable) {}
            }.should raise_error(TypeError)

            ScratchPad.recorded.should == []
          end
        end

        ruby_version_is "2.1" do
          it "accepts as a Proc" do
            enum = enumerator_class.new(@callable) {}
            ScratchPad.recorded.should == []
            enum.size.should == :returned_from_call
            ScratchPad.recorded.should == [:called]
          end
        end
      end
    end
  end
end
