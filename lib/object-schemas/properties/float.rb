module ObjectSchemas
  module Properties
    class Float < Property
      def matches_type?(value)
        return true if value.is_a? ::Float or value.is_a? ::BigDecimal
        return false
      end
    end
  end
end