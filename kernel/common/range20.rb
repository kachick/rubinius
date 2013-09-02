# -*- encoding: us-ascii -*-

class Range
  def size
    case
    when @end == Float::INFINITY
      case @begin
      when Float::INFINITY
        0
      when Numeric
        Float::INFINITY
      else
        nil
      end
    when @begin.kind_of?(Numeric) && @end.kind_of?(Numeric)
      if @begin.kind_of?(Float) || @end.kind_of?(Float)
        step_size = 1
        err = (@begin.abs + @end.abs + (@end - @begin).abs) / step_size.abs * Float::EPSILON
        err = 0.5 if err > 0.5
        if @excl
          n = ((@end - @begin) / step_size - err).floor
          n += 1 if n * step_size + @begin < @end
        else
          n = ((@end - @begin) / step_size + err).floor + 1
        end
        n
      else
        diff = (@excl ? @end : @end + 1) - @begin
        diff < 0 ? 0 : diff.to_int
      end
    else
      nil
    end
  end
end
