module Forester
  class TreeFactory
    def from_root_hash(root_hash, options = {})
      default_options = {
        max_depth: :none,
      }
      options = default_options.merge(options)

      options[:max_depth] = -2 if options[:max_depth] == :none

      dummy_root = TreeNode.new('<TEMP>')

      tree = with_children(dummy_root, [root_hash], options.fetch(:children_key), options[:max_depth] + 1).first_child
      tree.detached_subtree_copy
    end

    def node_from_content(content)
      TreeNode.new(SecureRandom.uuid, content)
    end

    private

    def with_children(tree_node, children, children_key, levels_remaining)
      return tree_node if levels_remaining == 0

      children.each do |child_hash|
        child_node     = node_from_hash(child_hash, children_key)
        child_children = child_hash.fetch(children_key, [])

        tree_node << with_children(child_node, child_children, children_key, levels_remaining - 1)
      end

      tree_node
    end

    def node_from_hash(hash, children_key)
      content = without_key(hash, children_key)
      node_from_content(content)
    end

    def without_key(hash, key)
      hash.dup.tap { |h| h.delete(key) }
    end
  end
end
