module DuckHunt
  module Properties
    class Integer < Property
      def matches_type?(value)
        return value.integer? rescue return false
      end
    end
  end
end