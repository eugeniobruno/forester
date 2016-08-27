module Forester
  module Mutators

    def add_field!(name, definition, options = {})
      default_options = {
        subtree: true
      }
      options = default_options.merge(options)

      if options[:subtree]
        each_node do |node|
          node.add_field!(name, definition, options.merge({ subtree: false }))
        end
      else
        value = definition.respond_to?(:call) ? definition.call(self) : definition
        put!(name, value)
      end
    end

    def remove_levels_past!(last_level_to_keep)
      nodes_of_level(last_level_to_keep).map(&:remove_all!)
      self
    end

  end
end
