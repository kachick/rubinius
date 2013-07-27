# -*- encoding: us-ascii -*-

module EnumeratorLazySpecs
  class MixedYieldAndRaiseError
    class Error < Exception; end

    def each(arg=:default_arg, *args)
      yield 0
      yield 1
      yield 2
      yield 3
      yield nil
      yield
      yield arg
      yield(*args)
      yield :multiple_yield1, :multiple_yield2

      ScratchPad << :after_yields

      raise Error

      ScratchPad << :after_error

      :should_not_reach_here
    end
  end
end
