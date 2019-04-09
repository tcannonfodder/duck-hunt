# Duck Hunt [![CircleCI](https://circleci.com/gh/tcannonfodder/duck-hunt.svg?style=svg)](https://circleci.com/gh/tcannonfodder/duck-hunt)
## A dependency-free object validator for Ruby

Duck Typing is pretty fantastic, but sometimes you need to be sure your inputs match what you expect.

REST APIs are a great example: you've defined the structure of your endpoints and the parameters you expect, down to the datatype. Now you *could* throw in a bunch of conditionals to check input parameters, but that gets out of hand quickly and is a nightmare to maintain.

What if you could define how an object should look, and check if you're getting back what you expect.

So instead of:

~~~ruby
def search
  unless params[:user].present? and params[:user][:name].present? and params[:user][:age].present? and params[:user][:age].is_a? Integer and params[:user][:age] > 0 # ... you get the point
    head :bad_request and return
  end

  # After that mouthful, actually do something

end
~~~

You have:

~~~ruby
module UserSchemas
  def search
    DuckHunt::Schemas::HashSchema.define :strict_mode => true do |user|
      user.string  "name", :required => true, :allow_nil => false
      user.integer "age", :required => true,  :allow_nil => false, :greater_than => 0
      user.nested_hash "address", :required => true do |address|
        address.string "state", :required => true
        address.string "city",  :required => false
      end
    end
  end
end

class UserAPI
  def search
    head :bad_request and return unless UserSchemas.create.validate?(params[:user])

    # the rest of your API call
  end
end
~~~

It's also *blazing fast*, since it's dependency-free and deals with plain Ruby objects.


## Installation notes

Just add the following to your Gemfile:

~~~ruby
gem 'duck-hunt'
~~~

## Requirements

Ruby 1.8.7+

That's it. This library was designed to be dependency-free, built entirely with Ruby. There are some parts that have been borrowed from activesupport, but they're baked into the library.


## How it works

A schema has multiple properties, which can have multiple validators. That sounds complex, but the syntax is designed to help you understand exactly how an object's defined.

### Schemas

Schemas are the top-level structure of the object. There are two types of Schemas: a Hash and an Array. These are the two types of objects you'll be checking.

You define a schema using the following syntax:

~~~ruby
DuckHunt::Schemas::HashSchema.define do |hash|
  # define hash key/valaue pairings here
end

# OR

DuckHunt::Schemas::ArraySchema.define do |array|
  # define array entry properties here
end
~~~

`define` returns an instance of the schema defined by the block you gave it. Calling `validate?` on this instance with a ruby object validates the object against the and returns a boolean. If the object is not valid, the `errors` method returns the errors explaining what went wrong

~~~ruby
schema = DuckHunt::Schemas::HashSchema.define do |x|
  x.string "name"
end

schema.validate?(:name => "hey")
#=> true

schema.validate?(:name => 12)
#=> false

schema.errors
#=> {"name"=>["wrong type"]}
~~~

#### Hash Schemas

When using Duck Hunt to validate hashes, you're asking "does this hash have the following keys, and is the key's value what I expect?"

The basic syntax for defining a hash schema is:

~~~ruby
DuckHunt::Schemas::HashSchema.define do |x|
  #x.key_type "key_name", :any_other => 1, :validators => true

  x.string "name", :matches => /\w+\s\w+/
  x.string "title", :required => false
end
~~~

Any property added to the hash schema is required by default. You can change that behavior by adding `:required => false` to the property definition. For clarity, I recommend always setting the `:required` option.

A property can only be defined in a schema once. Otherwise, a `DuckHunt:::PropertyAlreadyDefined` exception is thrown.

There are two types of validation for hash schemas: Strict and Relaxed. The validation type is controlled by the `:strict_mode` option in the `define` method.

##### Strict Validation

Strict Validation is the default type of validation for a Hash Schema. It validates that the object does not have any keys that are not defined in the schema:

~~~ruby
strict_schema = DuckHunt::Schemas::HashSchema.define, :strict_mode => true do |x|
  x.string "name"
end

strict_schema.validate?({:name => "Jane"})
#=> true

strict_schema.validate?({:name => "Jane", :age => 21})
#=> false

strict_schema.errors
#=> {"base"=>["has properties not defined in schema"]}
~~~

##### Relaxed Validation

Relaxed validation does not care if the object has keys that are not defined in the schema:

~~~ruby
relaxed_schema = DuckHunt::Schemas::HashSchema.define, :strict_mode => false do |x|
  x.string "name"
end

relaxed_schema.validate?({:name => "Jane"})
#=> true

relaxed_schema.validate?({:name => "Jane", :age => 21})
#=> true
~~~


##### Allowing a nil object

If you don't care whether the object is `nil` or not, you can set `:allow_nil => true` in the `define` method:

~~~ruby
nil_schema = DuckHunt::Schemas::HashSchema.define, :allow_nil => false do |x|
  x.string "name"
end

nil_schema.validate?({:name => "Jane"})
#=> true

nil_schema.validate?(nil)
#=> true
~~~

#### Array Schemas

When using Duck Hunt to validate hashes, you're asking "does this array contain the values that I expect?" There are two types of Array Schemas, each with vastly different definitions and behaviors.

##### Single-type Arrays

A single type array means that every item in the array has the same type and matches the same properties.

You define a single type array by adding a single property in the schema definition:

~~~ruby
schema = DuckHunt::Schemas::ArraySchema.define do |x|
  x.integer
end

schema.validate?([1,2,3])
#=> true

schema.validate?([1,"whoops",3])
#=> false

schema.errors
#=> {"1"=>["wrong type"]}
~~~

You can also set a minmum size for the array, a maximum size, or both!

~~~ruby
minimum_schema = DuckHunt::Schemas::ArraySchema.define :min_size => 2 do |x|
  x.integer
end

minimum_schema.validate?([1,2])
#=> true

minimum_schema.validate?([1])
#=> false

minimum_schema.errors
#=> {"base" => ["expected at least 2 item(s) but got 1 item(s)"]}
~~~

~~~ruby
max_schema = DuckHunt::Schemas::ArraySchema.define :max_size => 2 do |x|
  x.integer
end

max_schema.validate?([1,2])
#=> true

max_schema.validate?([1,2,3])
#=> false

max_schema.errors
#=> {"base" => ["expected at most 2 item(s) but got 3 item(s)"]}
~~~

~~~ruby
max_schema = DuckHunt::Schemas::ArraySchema.define :min_size => 2 :max_size => 3 do |x|
  x.integer
end

max_schema.validate?([1])
#=> false

max_schema.errors
#=> {"base" => ["expected at least 2 item(s) but got 1 item(s)"]}

max_schema.validate?([1,2])
#=> true

max_schema.validate?([1,2,3])
#=> true

max_schema.validate?([1,2,3,4])
#=> false

max_schema.errors
#=> {"base" => ["expected at most 3 item(s) but got 4 item(s)"]}
~~~

##### Tuple Arrays

A tuple array is an ordered array that can have mixed types. It expects a defined number of required items, and may have optional items at the end of the array. All items in the array must match the type defined for that index.

To define the required items for a tuple array, you call `items` in the `define` block:

~~~ruby
tuple_schema = DuckHunt::Schemas::ArraySchema.define do |x|
  x.items do |s|
    s.integer
    s.string
  end
end

tuple_schema.validate?([1,"hello"])
#=> true

tuple_schema.validate?([1])
#=> false

tuple_schema.errors
#=> { "base" => "expected at least 2 item(s) but got 1 item(s)"}

tuple_schema.validate?([1,"hello", 3])
#=> false

tuple_schema.errors
#=> { "base" => "expected at most 2 item(s) but got 3 item(s)"}

tuple_schema.validate?([1,2])
#=> false

tuple_schema.errors
#=> { "1" => "wrong type" }
~~~

Likewise, to define to optional itmes for a tuple array, you call `optional_items` in the `define` block. **Note that the object does not have to have *every* optional item.**

~~~ruby
tuple_schema = DuckHunt::Schemas::ArraySchema.define do |x|
  x.items do |s|
    s.integer
    s.string
  end

  x.optional_items do |y|
    y.string
    y.integer
  end
end

tuple_schema.validate?([1,"hello"])
#=> true

tuple_schema.validate?([1,"hello", 3])
#=> false

tuple_schema.errors
#=> { "2" => "wrong type"}

tuple_schema.validate?([1,"hello", "world"])
#=> true

tuple_schema.validate?([1,"hello", "world", 3, 4])
#=> false

tuple_schema.errors
#=> { "base" => "expected at most 4 item(s) but got 5 item(s)"}
~~~

##### Allowing a nil object

If you don't care whether the object is `nil` or not, you can set `:allow_nil => true` in the `define` method:

~~~ruby
nil_schema = DuckHunt::Schemas::Array.define, :allow_nil => false do |x|
  x.integer
end

nil_schema.validate?([1,2,3])
#=> true

nil_schema.validate?(nil)
#=> true
~~~

### Properties

Properties are the datatypes you can validate against in your schemas. They cover the basic datatypes you'd see when converying JSON to a ruby object:

* Array
* Boolean
* Float
* Integer
* Nested Hash
* Nil
* String

#### Nested Arrays and Hashes

Sometimes you need nested objects, like nested hashes or multi-dimensional arrays. It's really easy to define these in Duck Hunt:

~~~
nested_hash = DuckHunt::Schemas::HashSchema.define do |x|
  x.nested_hash "name" do |s|
    s.string "first_name"
    s.string "last_name"
  end
end

nested_hash.validate?({:name => {:first_name => "Jane", :last_name => "Doe"}})
#=> true

nested_hash.validate?({:name => "hello"})
#=> false

nested_hash.errors
#=> {"name"=>{"base"=>["wrong type"]}}

nested_hash.validate?({:name => {:first_name => "Jane", :last_name => 1}})
#=> false

nested_hash.errors
#=> {"name"=>{"last_name"=>["wrong type"]}}
~~~

~~~ruby
multi_array = DuckHunt::Schemas::ArraySchema.define do |x|
  x.array do |y|
    y.integer
  end
end

multi_array.validate?([[1,2],[3,4]])
#=> true

multi_array.validate?([[1,2],"hello"])
#=> false

multi_array.errors
#=> {"1"=>{"base"=>["wrong type"]}}

multi_array.validate?([[1,2],["hello",4]])
#=> false

multi_array.errors
#=> {"1"=>{"0"=>["wrong type"]}}
~~~


### Validators

Validators can be attached to any property to check if the value follows certain behavior. Each validator has its own error message

#### Accepted Values

This property can only have the values in this list

~~~ruby
schema = DuckHunt::Schemas::HashSchema.define do |x|
  x.integer "cats" :accepted_values => [1,2,3]
end

schema.validates?({:cats => 4})
#=> false

schema.errors
#=> {"0" => "not an accepted value"}
~~~

#### Rejected Values

This property cannot have any of the values in this list

~~~ruby
schema = DuckHunt::Schemas::HashSchema.define do |x|
  x.integer "cats" :rejected_values => [1,2,3]
end

schema.validates?({:cats => 1})
#=> false

schema.errors
#=> {"0" => "a rejected value"}
~~~

### Matches Regular Expression

This property is only valid if it matches the regular expression given

~~~ruby
schema = DuckHunt::Schemas::HashSchema.define do |x|
  x.string "name" :matches => /\w+\s\w+/
end

schema.validates?({ :name => "Bob" })
#=> false

schema.errors
#=> {"0" => "No matches for Regexp"}
~~~

#### Divisible By

This property is only valid if it's divisble by the number provided

~~~ruby
schema = DuckHunt::Schemas::HashSchema.define do |x|
  x.integer "cats" :divisible_by => 3
end

schema.validates?({:cats => 4})
#=> false

schema.errors
#=> {"0" => "not divisible by `3`"}
~~~

#### Not Divisible By

This property is only valid if it's not divisble by the number provided

~~~ruby
schema = DuckHunt::Schemas::HashSchema.define do |x|
  x.integer "cats" :not_divisible_by => 3
end

schema.validates?({:cats => 6})
#=> false

schema.errors
#=> {"0" => "divisible by `3`"}
~~~

#### Standard comparisons: equal to, greater than (or equal to), less than (or equal to), not equal to

This property is only valid if it fits the comparison. The comparisons defined are:

* `:equal_to`
* `:not_equal_to`
* `:greater_than`
* `:greater_than_or_equal_to`
* `:less_than`
* `:less_than_or_equal_to`

~~~ruby
schema = DuckHunt::Schemas::HashSchema.define do |x|
  x.integer "cats" :greater_than => 4
end

schema.validates?({:cats => 4})
#=> false

schema.errors
#=> {"0" => "not greater than `4`"}
~~~

~~~ruby
schema = DuckHunt::Schemas::HashSchema.define do |x|
  x.integer "name" :equal => "bob"
end

schema.validates?({:name => "Jim"})
#=> false

schema.errors
#=> {"0" => "not equal to `bob`"}
~~~