module DuckHunt
  module Properties
    class Boolean < Property
      def matches_type?(value)
        return true if value.is_a? ::TrueClass or value.is_a? ::FalseClass
        return false
      end
    end
  end
end