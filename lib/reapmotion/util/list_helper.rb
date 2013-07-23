module ReapMotion
  module ListHelper
    include Enumerable

    def <<(other)
      append(other)
    end

    def [](index)
      get(index)
    end

    def each
      iter = iterator
      while iter.has_next
        yield iter.next
      end
    end
  end
end
