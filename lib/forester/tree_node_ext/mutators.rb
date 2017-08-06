module Forester
  module Mutators
    def change_parent_to(new_parent_node, options = {})
      default_options = {
        subtree: true
      }
      options = default_options.merge(options)

      children.each { |child| parent.add(child) } unless options[:subtree]

      new_parent_node.add(self) # always as its last child
    end

    def add_child_content(content)
      new_node = Forester.tree_factory.node_from_content(content)
      add(new_node)
    end

    def add_field_in_node(name, definition)
      value = definition.respond_to?(:call) ? definition.call(self) : definition

      content[name] = value
    end

    def add_fields_in_node(fields)
      fields.each do |field|
        add_field_in_node(field[:name], field[:definition])
      end
    end

    def add_field_in_subtree(name, definition)
      add_fields_in_subtree([name: name, definition: definition])
    end

    def add_fields_in_subtree(fields)
      each_node { |node| node.add_fields_in_node(fields) }
    end

    def delete_values_in_node(field, values, options = {})
      default_options = {
        percolate: false
      }
      options = default_options.merge(options)

      return unless has_field?(field)
      current_value = get(field)

      operation = options[:percolate] ? :& : :-
      return unless current_value.respond_to?(operation)

      new_value = current_value.public_send(operation, as_array(values))

      content[field] = new_value
    end

    def delete_values_in_subtree(field, values, options = {})
      default_options = {
        percolate: false
      }
      options = default_options.merge(options)

      each_node { |node| node.delete_values_in_node(field, values, options) }
    end

    def remove_levels_past(last_level_to_keep)
      unless last_level_to_keep >= 1
        raise ArgumentError, "expected a positive integer, got #{last_level_to_keep}"
      end

      nodes_of_level(last_level_to_keep).map(&:remove_all!)
      self
    end
  end
end
