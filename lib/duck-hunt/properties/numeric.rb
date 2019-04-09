module DuckHunt
  module Properties
    class Numeric < Property
      def matches_type?(value)
        return true if (value.is_a?(::Float) || value.is_a?(::BigDecimal) || (value.integer? rescue return false))
        return false
      end
    end
  end
end