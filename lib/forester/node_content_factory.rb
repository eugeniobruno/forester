module Forester
  class NodeContentFactory

    class << self

      def from_hash(hash, children_key)
        NodeContent.new(HashWithIndifferentAccess.new(without_key(hash, children_key)))
      end

      private

      def without_key(hash, key)
        hash.reject { |k, _| k.to_s == key.to_s }
      end

    end

  end
end