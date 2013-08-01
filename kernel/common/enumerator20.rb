# -*- encoding: us-ascii -*-

module Enumerable
  class Enumerator
    def initialize(object_or_size=undefined, iter=:each, *args, &block)
      if block_given?
        if undefined.equal? object_or_size
          size = nil
        else
          size = object_or_size
        end

        object = Generator.new(&block)
      else
        if undefined.equal? object_or_size
          raise ArgumentError, "Enumerator#initialize requires a block when called without arguments"
        end

        object = object_or_size
      end

      @object = object
      @size = size
      @iter = Rubinius::Type.coerce_to iter, Symbol, :to_sym
      @args = args
      @generator = nil
      @lookahead = []

      self
    end
    private :initialize

    def each(*args, &block)
      if block_given?
        @object.__send__(@iter, *@args, *args, &block)
      else
        unless args.empty?
          @args = [*@args, *args]
        end

        self
      end
    end

    def size
      @size.kind_of?(Proc) ? @size.call : @size
    end

    class Lazy < self
      class StopLazyError < Exception; end

      def initialize(receiver, size=nil)
        raise ArgumentError, "Lazy#initialize requires a block" unless block_given?
        Rubinius.check_frozen

        super(size) do |yielder|
          begin
            receiver.each do |*args|
              yield yielder, *args
            end
          rescue StopIteration
          end
        end

        self
      end
      private :initialize

      alias_method :force, :to_a

      def take(n)
        n = Rubinius::Type.coerce_to n, Integer, :to_int
        raise ArgumentError, "attempt to take negative size" if n < 0

        current_size = enumerator_size
        set_size = if current_size.kind_of?(Integer)
          n < current_size ? n : current_size
        else
          current_size
        end

        taken = 0
        Lazy.new(self, set_size) do |yielder, *args|
          if taken < n
            yielder.<<(*args)
            taken += 1
          else
            raise StopLazyError
          end
        end
      end

      def map
        raise ArgumentError, 'Lazy#{map,collect} requires a block' unless block_given?

        Lazy.new(self, enumerator_size) do |yielder, *args|
          yielder << yield(*args)
        end
      end
      alias_method :collect, :map
    end
  end
end
