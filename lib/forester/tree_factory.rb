module Forester
  class TreeFactory

    class << self

      def from_yaml_file(file)
        from_hash_with_root_key(YAML.load_file(file))
      end

      def from_root_hash(hash, children_key = :children)
        from_hash_with_root_key({ root: hash }, children_key)
      end

      def from_hash_with_root_key(hash, children_key = :children, root_key = :root)
        dummy_root = TreeNode.new('<TEMP>')
        real_root  = fetch_indifferently(hash, root_key)

        tree = with_children(dummy_root, [real_root], children_key).first_child
        tree.detached_subtree_copy
      end

      def from_hash(hash, children_key, uid = SecureRandom.uuid)
        name = uid
        content = NodeContent::Factory.from_hash(hash, children_key)
        TreeNode.new(name, content)
      end

      private

      def fetch_indifferently(hash, key, default = nil)
        [key, key.to_s, key.to_s.to_sym].uniq.map { |k| hash[k] }.compact.first || default || hash.fetch(root_key)
      end

      def with_children(tree_node, children, children_key)
        children.each do |child|
          child_node     = from_hash(child, children_key)
          child_children = fetch_indifferently(child, children_key, []) # nth level

          tree_node << with_children(child_node, child_children, children_key)
        end
        tree_node
      end

    end

  end
end