module Forester
  module Views

    def as_nested_hash(options = {})
      default_options = {
        fields_to_include: fields, # all of them
        stringify_keys:    false,
        symbolize_keys:    false
      }
      options = default_options.merge(options)

      hash = content.to_hash(options)

      children_key = :children
      children_key = children_key.to_s if options[:stringify_keys]

      hash.merge(
        {
          children_key => children.map { |node| node.as_nested_hash(options) }
        }
      )
    end

  end
end