module Forester
  class HashWithIndifferentAccess < SimpleDelegator

    def has_key?(key)
      equivs(key).any? { |k| super(k) }
    end

    def fetch(key, default = nil, &block)
      maybe_key = equivs(key).select { |k| __getobj__.has_key?(k) }
      if maybe_key.empty?
        super(key)
      else
        super(maybe_key.first)
      end
    end

    def [](key)
      equivs(key).map { |k| super(k) }.compact.first || super
    end

    protected

    def equivs(key)
      [key.to_sym, key.to_s]
    end

  end
end