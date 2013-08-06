# -*- encoding: us-ascii -*-

module Enumerable
  class Enumerator
    attr_writer :args
    private :args=
    
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
      enumerator = self
      new_args = @args

      unless args.empty?
        enumerator = dup
        unless @args.empty?
          new_args = @args + args
        else
          new_args = args
        end
      end

      Rubinius.privately do
        enumerator.args = new_args
      end

      if block_given?
        Rubinius.privately do
          enumerator.each!(&block)
        end
      else
        enumerator
      end
    end

    def size
      @size.kind_of?(Proc) ? @size.call : @size
    end

    class Generator
      def each(*args)
        enclosed_yield = Proc.new { |*enclosed_args| yield *enclosed_args }

        @proc.call Yielder.new(&enclosed_yield), *args
      end
    end

    class Lazy < self
      class StopLazyError < Exception; end

      def initialize(receiver, size=nil)
        raise ArgumentError, "Lazy#initialize requires a block" unless block_given?
        Rubinius.check_frozen

        super(size) do |yielder, *each_args|
          begin
            receiver.each(*each_args) do |*args|
              yield yielder, *args
            end
          rescue Exception
          end
        end

        self
      end
      private :initialize

      def lazy
        self
      end

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

      def drop(n)
        n = Rubinius::Type.coerce_to n, Integer, :to_int
        raise ArgumentError, "attempt to drop negative size" if n < 0

        current_size = enumerator_size
        set_size = if current_size.kind_of?(Integer)
          n < current_size ? current_size - n : 0
        else
          current_size
        end

        dropped = 0
        Lazy.new(self, set_size) do |yielder, *args|
          if dropped < n
            dropped += 1
          else
            yielder.<<(*args)
          end
        end
      end

      def take_while
        raise ArgumentError, "Lazy#take_while requires a block" unless block_given?

        Lazy.new(self, nil) do |yielder, *args|
          if yield(*args)
            yielder.<<(*args)
          else
            raise StopLazyError
          end
        end
      end

      def drop_while
        raise ArgumentError, "Lazy#drop_while requires a block" unless block_given?

        succeeding = true
        Lazy.new(self, nil) do |yielder, *args|
          if succeeding
            unless yield(*args)
              succeeding = false
              yielder.<<(*args)
            end
          else
            yielder.<<(*args)
          end
        end
      end

      def select
        raise ArgumentError, 'Lazy#{select,find_all} requires a block' unless block_given?

        Lazy.new(self, nil) do |yielder, *args|
          yielder.<<(*args) if yield(*args)
        end
      end
      alias_method :find_all, :select

      def reject
        raise ArgumentError, "Lazy#reject requires a block" unless block_given?

        Lazy.new(self, nil) do |yielder, *args|
          yielder.<<(*args) unless yield(*args)
        end
      end

      def grep(pattern)
        if block_given?
          Lazy.new(self, nil) do |yielder, *args|
            val = args.length >= 2 ? args : args.first
            if pattern === val
              Regexp.set_block_last_match
              yielder << yield(val)
            end
          end
        else
          Lazy.new(self, nil) do |yielder, *args|
            val = args.length >= 2 ? args : args.first
            if pattern === val
              Regexp.set_block_last_match
              yielder << val
            end
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
