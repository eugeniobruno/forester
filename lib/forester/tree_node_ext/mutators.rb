module Forester
  module Mutators

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

    def remove_levels_past!(last_level_to_keep)
      nodes_of_level(last_level_to_keep).map(&:remove_all!)
      self
    end

  end
end
