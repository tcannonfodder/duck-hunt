module ObjectSchemas
  module Properties
    class String < Property
      def matches_type?(value)
        return true if value.is_a? ::String
        return false
      end
    end
  end
end