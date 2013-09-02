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
        float_diff 1
      else
        diff = (@excl ? @end : @end + 1) - @begin
        diff < 0 ? 0 : diff.to_int
      end
    else
      nil
    end
  end
end
