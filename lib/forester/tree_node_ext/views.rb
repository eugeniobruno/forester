module Forester
  module Views

    def as_root_hash(options = {})
      default_options = {
        fields_to_include: :all,
        max_level:         :last,
        children_key:      :children,
        stringify_keys:    false,
        symbolize_keys:    false
      }
      options = default_options.merge(options)

      hash = content.to_hash(options)

      children_key = options[:children_key]
      children_key = children_key.to_s if options[:stringify_keys]

      max_level = options[:max_level]
      max_level = -1 if max_level == :last

      next_children =
        if max_level == 0
          []
        else
          next_options = options.merge({ max_level: max_level - 1 })
          children.map { |node| node.as_root_hash(next_options) }
        end

      hash.merge({ children_key => next_children })
    end

  end
end
