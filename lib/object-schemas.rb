#add support for camelization (to make property/validation lookup easier)
class String
	def self.camelize(lower_case_and_underscored_word, first_letter_in_uppercase = true)
	  if first_letter_in_uppercase
	    lower_case_and_underscored_word.to_s.gsub(/\/(.?)/) { "::" + $1.upcase }.gsub(/(^|_)(.)/) { $2.upcase }
	  else
	    lower_case_and_underscored_word.first + camelize(lower_case_and_underscored_word)[1..-1]
	  end
	end

	def camelize(first_letter = :upper)
	  case first_letter
	  when :upper
	    self.class.camelize(self, true)
	  when :lower
	    self.class.camelize(self, false)
	  end
  end
end

#Support `stringify_keys` and `symbolize_keys`
class Hash
	def stringify_keys!
    keys.each do |key|
      self[key.to_s] = delete(key)
    end
    self
  end

  def stringify_keys
  	dup.stringify_keys!
  end

  def symbolize_keys!
    keys.each do |key|
      self[(key.to_sym rescue key) || key] = delete(key)
    end
    self
  end

  def symbolize_keys
  	dup.symbolize_keys!
  end
end


module ObjectSchemas
	class MethodNotDefined < StandardError; end
	class AbstractClass < StandardError; end
	class PropertyAlreadyDefined < StandardError; end

	autoload :Schemas, File.dirname(__FILE__) + '/object-schemas/schemas.rb'
	autoload :Properties, File.dirname(__FILE__) + '/object-schemas/properties.rb'
  autoload :Validators, File.dirname(__FILE__) + '/object-schemas/validators.rb'
end