module Forester
  class NodeContent

    def initialize(hash)
      @hash = HashWithIndifferentAccess.new(hash)
    end

    def field_names
      @hash.keys
    end

    def to_hash
      @hash.each_with_object({}) do |(k, v), hash|
        hash[k.to_sym] = v
      end
    end

    def set!(key, value)
      @hash[key] = value
    end

    def method_missing(name, *args, &block)
      if @hash.has_key?(name)
        @hash.fetch(name)
      elsif block_given?
        yield self
      else
        raise ArgumentError.new("the node \"#{self.name}\" does not have any \"#{name}\"")
      end
    end

    def respond_to_missing?(name, include_private = false)
      @hash.has_key?(name) || super
    end

  end
end