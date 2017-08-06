module Forester
  module Serializers
    def as_root_hash(options = {})
      default_options = {
        max_depth:      :none,
        children_key:   'children',
        stringify_keys: false,
        symbolize_keys: false,
        include_fields: :all,
        exclude_fields: :none
      }
      options = default_options.merge(options)

      max_depth = options[:max_depth]
      max_depth = -1 if max_depth == :none

      adjusted_content = content.each_with_object(content.class.new) do |(k, v), h|
        adjusted_key = k
        adjusted_key = k.to_s   if options[:stringify_keys]
        adjusted_key = k.to_sym if options[:symbolize_keys]

        unless options[:include_fields] == :all
          next unless options[:include_fields].include?(adjusted_key)
        end

        unless options[:exclude_fields] == :none
          next if options[:exclude_fields].include?(adjusted_key)
        end

        h[adjusted_key] = v
      end

      children_key = options[:children_key]
      children_key = children_key.to_s   if options[:stringify_keys]
      children_key = children_key.to_sym if options[:symbolize_keys]

      next_children =
        if max_depth == 0
          []
        else
          next_options = options.merge(max_depth: max_depth - 1)
          children.map { |node| node.as_root_hash(next_options) }
        end

      adjusted_content.merge(children_key => next_children)
    end
  end
end
