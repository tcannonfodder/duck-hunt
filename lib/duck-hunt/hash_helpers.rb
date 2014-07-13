# Support `stringify_keys` and `symbolize_keys`
# keep these methods in their own modules so they don't conflict with other libraries that might
# be loaded (e.g: activesupport)
module DuckHunt
  module HashHelpers
    def self.stringify_keys!(hash)
      hash.keys.each do |key|
        hash[key.to_s] = hash.delete(key)
      end
      return hash
    end

    def self.stringify_keys(hash)
      return stringify_keys!(hash.dup)
    end

    def self.symbolize_keys!(hash)
      hash.keys.each do |key|
        hash[(key.to_sym rescue key) || key] = hash.delete(key)
      end
      return hash
    end

    def self.symbolize_keys(hash)
      return symbolize_keys!(hash.dup)
    end
  end
end