module Forester
  class TreeNode < Tree::TreeNode

    include Aggregators

    def ancestry(include_root = true, include_self = false, descending = true)
      ancestors = self.parentage          || []
      ancestors = ancestors[0...-1]       unless include_root
      ancestors = ancestors.unshift(self) if     include_self
      if descending then ancestors.reverse else ancestors end
    end

    def nodes_of_level(l)
      if l.between?(0, max_level) then each_level.take(l + 1).last else [] end
    end

    def max_level
      node_height
    end

    def each_level
      breadth_each.slice_before { |node| !node.is_last_sibling? }
    end

    def get(field, &block)
      content.public_send(field, &block)
    end

    def contents
      each_node.map(&:content)
    end

    def each_node
      breadth_each
    end

  end
end
