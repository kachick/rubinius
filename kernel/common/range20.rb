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
      diff = @end - @begin
      diff < 0 ? 0 : diff.to_int
    else
      nil
    end
  end
end
