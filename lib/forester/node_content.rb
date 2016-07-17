module Forester
  class NodeContent

    def initialize(hash)
      @hash = HashWithIndifferentAccess.new(hash)
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