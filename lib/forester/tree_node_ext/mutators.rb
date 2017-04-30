module Forester
  module Mutators

    def add_child_content(content, options = {}, &block)
      new_node = TreeFactory.node(content, options, &block)
      add(new_node)
    end

    def add_field!(name, definition, options = {})
      add_fields!([{ name: name, definition: definition }], options)
    end

    def add_fields!(fields, options = {})
      default_options = {
        subtree: true
      }
      options = default_options.merge(options)

      target_nodes = options[:subtree] ? each_node : [self]

      target_nodes.each { |node| node.add_fields_to_root!(fields) }
    end

    def add_fields_to_root!(fields)
      fields.each do |field|
        value = field[:definition]
        value = value.call(self) if value.respond_to?(:call)

        put!(field[:name], value)
      end
    end

    def delete_values!(field, values, options = {})
      default_options = {
        percolate: false,
        subtree:   true
      }
      options = default_options.merge(options)

      target_nodes = options[:subtree] ? each_node : [self]

      target_nodes.each { |node| node.delete_values_from_root!(field, values, options[:percolate]) }
    end

    def delete_values_from_root!(field, values, percolate)
      return unless has?(field)
      current_value = get(field)
      return unless current_value.is_a?(Array)

      new_value =
        if percolate
          current_value & as_array(values)
        else
          current_value - as_array(values)
        end

      put!(field, new_value)
    end

    def percolate_values!(field, values, options = {})
      delete_values!(field, values, options.merge(percolate: true))
    end

    def remove_levels_past!(last_level_to_keep)
      nodes_of_level(last_level_to_keep).map(&:remove_all!)
      self
    end

  end
end
