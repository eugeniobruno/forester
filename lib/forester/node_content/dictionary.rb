module Forester
  module NodeContent
    class Dictionary < Base

      def fields
        keys
      end

      def has_key?(key, indifferent = true)
        if indifferent
          equivs(key).any? { |k| super(k) }
        else
          super(key)
        end
      end
      alias_method :has?, :has_key?

      def [](key)
        super(best key)
      end

      def fetch(key, default = :yield_to_block, &block)
        best_key = best key
        if default == :yield_to_block
          super(best_key, &block)
        else
          super(best_key, default, &block)
        end
      end
      alias_method :get, :fetch

      def []=(key, value, options = {})
        default_options = {
          symbolize_key: true
        }
        options = default_options.merge(options)

        convert_key = ->(k) { k }
        convert_key = ->(k) { k.to_sym } if options[:symbolize_key]

        super(convert_key.call(key), value)
      end
      alias_method :put!, :[]=

      def delete(key, default = :yield_to_block, &block)
        best_key = best key
        if default == :yield_to_block
          super(best_key, &block)
        else
          super(best_key, default, &block)
        end
      end
      alias_method :del!, :delete

      def to_hash(options = {})
        default_options = {
          fields_to_include: fields, # all of them
          stringify_keys:    false,
          symbolize_keys:    false
        }
        options = default_options.merge(options)
        options[:fields_to_include] = fields if options[:fields_to_include] == :all

        convert_key = ->(k) { k }
        convert_key = ->(k) { k.to_s }   if options[:stringify_keys]
        convert_key = ->(k) { k.to_sym } if options[:symbolize_keys]

        each_with_object({}) do |(k, v), hash|
          if equivs(k).any? { |eq| options[:fields_to_include].include?(eq) }
            hash[convert_key.call(k)] = v
          end
        end
      end

      def merge(dictionary)
        self.class.new(super)
      end

      protected

      def equivs(key)
        [key, key.to_s, key.to_s.to_sym].uniq
      end

      def best(key)
        equivs(key).find { |k| has_key?(k, false) } || key
      end

    end
  end
end
