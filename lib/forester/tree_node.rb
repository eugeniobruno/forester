module Forester
  class TreeNode < Tree::TreeNode
    include Iterators
    include Mutators
    include Validators
    include Serializers

    def node_level
      node_depth + 1
    end

    def nodes_of_depth(d) # relative to this node
      d.between?(0, node_height) ? each_level.take(d + 1).last : []
    end

    def nodes_of_level(l)
      nodes_of_depth(l - 1)
    end

    def path_from_root
      (parentage || []).reverse + [self]
    end

    def paths_to_leaves
      paths_to(leaves)
    end

    def paths_to(descendants)
      descendants.map { |node| node.path_from_root.drop(node_depth) }
    end

    def leaf?
      is_leaf?
    end

    def leaves
      each_leaf
    end

    def paths_of_length(l)
      paths_to(nodes_of_depth(l))
    end

    def leaves_when_pruned_to_depth(d)
      ret = []
      each_node(traversal: :breadth_first) do |node|
        relative_depth_of_descendant = node.node_depth - node_depth
        break if relative_depth_of_descendant > d
        ret.push(node) if node.leaf? || (relative_depth_of_descendant == d)
      end

      ret
    end

    def leaves_when_pruned_to_level(l)
      leaves_when_pruned_to_depth(l - 1)
    end

    def paths_to_leaves_when_pruned_to_depth(d)
      paths_to(leaves_when_pruned_to_depth(d))
    end

    def paths_to_leaves_when_pruned_to_level(l)
      paths_to(leaves_when_pruned_to_level(l))
    end

    def get(field, default = :raise)
      if has_field?(field)
        content[field]
      elsif block_given?
        yield(field, self)
      elsif default != :raise
        default
      else
        missing_key =
          if field.is_a?(Symbol)
            ":#{field}"
          elsif field.is_a?(String)
            "'#{field}'"
          else
            field
          end
        error_message = "key not found: #{missing_key} in node content \"#{content}\""
        raise KeyError, error_message
      end
    end

    def has_field?(field)
      content.key?(field)
    end

    private

    def as_array(object)
      [object].flatten(1)
    end
  end
end
