module Forester
  module Views

    def as_nested_hash(options = {})
      default_options = {
        fields_to_include: field_names,
        stringify_keys: false
      }
      options = default_options.merge(options)

      hash = content.to_hash
      hash.select! { |k, _| options[:fields_to_include].map(&:to_s).include? k.to_s }
      hash = hash.each_with_object({}) { |(k, v), h| h[k.to_s] = v } if options[:stringify_keys]

      children_key = :children
      children_key = children_key.to_s if options[:stringify_keys]

      hash.merge({ children_key => children.map { |node| node.as_nested_hash(options) } })
    end

  end
end