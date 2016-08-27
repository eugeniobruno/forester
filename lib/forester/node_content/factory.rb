module Forester
  module NodeContent
    class Factory

      class << self

        def from_hash(hash, children_key, indifferent = true)
          ret = without_key(hash, children_key)
          ret = Dictionary.new(ret) if indifferent
          ret
        end

        def from_array(array)
          List.new(array)
        end

        private

        def without_key(hash, key)
          hash.reject { |k, _| k.to_s == key.to_s }
        end

      end

    end
  end
end
