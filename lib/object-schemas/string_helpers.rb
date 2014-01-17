# add support for camelization (to make property/validation lookup easier)
# keep these methods in their own modules so they don't conflict with other libraries that might
# be loaded (e.g: activesupport)
module ObjectSchemas
  module StringHelpers
    def self.camelize(string, first_letter = :upper)
      case first_letter
      when :upper
        self.camelize_string(string, true)
      when :lower
        self.camelize_string(string, false)
      end
    end

    protected

    def self.camelize_string(lower_case_and_underscored_word, first_letter_in_uppercase = true)
      if first_letter_in_uppercase
        lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
      else
        lower_case_and_underscored_word.first + camelize(lower_case_and_underscored_word)[1..-1]
      end
    end
  end
end