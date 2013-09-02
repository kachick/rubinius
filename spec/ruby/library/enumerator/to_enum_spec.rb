require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is ""..."1.8.7" do
  require 'enumerator'
  require File.expand_path('../../../shared/enumerator/enum_for', __FILE__)

  describe "Kernel#to_enum" do
    it_behaves_like :enum_for, :to_enum
  end
end
