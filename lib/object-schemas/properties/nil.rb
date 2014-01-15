module ObjectSchemas
  module Properties
    class Nil < Property
      def initialize(options= {})
        super(options)
        @allow_nil = true
      end

      def matches_type?(value)
        return true if value.nil?
        return false
      end
    end
  end
end