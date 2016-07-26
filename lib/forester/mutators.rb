module Forester
  module Mutators

    def add_field!(name, definition)
      value = if definition.respond_to? :call then definition.call(self) else definition end
      content.set!(name, value)
    end

    def add_field_to_subtree!(name, definition)
      each_node { |node| node.add_field!(name, definition) }
    end

  end
end