# -*- encoding: us-ascii -*-

module EnumeratorLazySpecs
  class MixedYieldAndRaiseError
    class Error < Exception; end

    def each(arg=:default_arg, *args)
      yield
      yield 0
      yield 0, 1
      yield 0, 1, 2
      yield(*[0, 1, 2])
      yield nil
      yield arg
      yield args
      yield []
      yield [0]
      yield [0, 1]
      yield [0, 1, 2]

      ScratchPad << :after_yields

      raise Error

      ScratchPad << :after_error

      :should_not_reach_here
    end
  end
end
