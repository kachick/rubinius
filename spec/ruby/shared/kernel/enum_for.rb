
describe :enum_for, :shared => true do
  it "is defined in Kernel" do
    Kernel.method_defined?(@method).should be_true
  end

  it "returns a new enumerator" do
    Object.new.send(@method).should be_an_instance_of(enumerator_class)
  end

  it "defaults the first argument to :each" do
    enum = [1,2].send(@method)
    enum.map { |v| v }.should == [1,2].map { |v| v }
  end

  it "exposes multi-arg yields as an array" do
    o = Object.new
    def o.each
      yield :a
      yield :b1, :b2
      yield [:c]
      yield :d1, :d2
      yield :e1, :e2, :e3
    end

    enum = o.send(@method)
    enum.next.should == :a
    enum.next.should == [:b1, :b2]
    enum.next.should == [:c]
    enum.next.should == [:d1, :d2]
    enum.next.should == [:e1, :e2, :e3]
  end

  ruby_version_is "2.0" do
    describe "when given a block" do
      it "sets the block to own size" do
        n = 100
        enum = Object.new.send(@method) { n }
        n = 200
        enum.size.should == 200

        proc = Proc.new {}
        Object.new.send(@method) { proc }.size.should equal(proc)

        Object.new.send(@method) { nil }.size.should be_nil
      end
    end

    describe "when not given a block" do
      it "sets nil to own size" do
        Object.new.send(@method).size.should be_nil
      end
    end
  end
end
