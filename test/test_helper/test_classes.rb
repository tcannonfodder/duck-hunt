class DuckHunt::Properties::Test < DuckHunt::Properties::Property
end

class DuckHunt::Properties::TestBlockPassed < DuckHunt::Properties::Property
  attr_reader :block_passed
  def initialize(options={}, &block)
    @block_passed = true if block_given?
  end
end

class DuckHunt::Properties::AlwaysRightType < DuckHunt::Properties::Property
  def matches_type?(value)
    return true
  end
end

class DuckHunt::Properties::AlwaysWrongType < DuckHunt::Properties::Property
  def matches_type?(value)
    return false
  end
end

class DuckHunt::Validators::Test < DuckHunt::Validators::Validator
end

class DuckHunt::Validators::AlwaysWrong < DuckHunt::Validators::Validator
  def valid?(value)
    return false
  end

  def error_message
    "Always Wrong"
  end
end

class DuckHunt::Validators::WrongAgain < DuckHunt::Validators::Validator
  def valid?(value)
    return false
  end

  def error_message
    "Wrong Again"
  end
end

class DuckHunt::Validators::AlwaysRight < DuckHunt::Validators::Validator
  def valid?(value)
    return true
  end

  def error_message
    "How did this happen?"
  end
end

class DuckHunt::Validators::RightAgain < DuckHunt::Validators::Validator
  def valid?(value)
    return true
  end

  def error_message
    "Wha?"
  end
end

class DuckHunt::Validators::AlwaysRaiseException < DuckHunt::Validators::Validator
  def valid?(value)
    raise Exception, "Bad!"
  end

  def error_message
    "Bad!"
  end
end