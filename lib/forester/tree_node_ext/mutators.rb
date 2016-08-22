module Forester
  module Mutators

    def add_field!(name, definition)
      value = if definition.respond_to? :call then definition.call(self) else definition end
      put!(name, value)
    end

    def add_field_to_subtree!(name, definition)
      each_node { |node| node.add_field!(name, definition) }
    end

    def remove_levels_past!(last_level_to_keep)
      nodes_of_level(last_level_to_keep).map(&:remove_all!)
      self
    end

  end
end