class ObjectSchemas::Properties::Test < ObjectSchemas::Properties::Property
end

class TestSchema < ObjectSchemas::Schemas::Schema

  attr_accessor :favorite_show

  def initialize
    self.favorite_show = "Doctor Who"
    super
  end
end
