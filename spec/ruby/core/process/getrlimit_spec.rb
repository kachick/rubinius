require File.expand_path('../../../spec_helper', __FILE__)

# see setrlimit_spec.rb

describe "Process.getrlimit" do
  it "needs to be reviewed for spec completeness"

  describe "argument is a resource name" do
    ruby_version_is "" ... "1.9" do
      it "raises an TypeError" do
        lambda { Process.getrlimit "CORE" }.should raise_error(TypeError)
      end
    end

    ruby_version_is "1.9" do
      it "returns same value when recieve relative constant" do
        Process.getrlimit("CORE").should == Process.getrlimit(Process::RLIMIT_CORE)
      end

      describe "that does not relative to any constant" do
        it "raises an ArgumentError" do
          lambda { Process.getrlimit "THIS_IS_NOT_A_CONSTANT" }.should raise_error(ArgumentError)
        end
      end
    end
  end
end
