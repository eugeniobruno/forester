module Forester
  class TreeFactory

    class << self

      def from_yaml_file(file, options = {})
        from_hash_with_root_key(YAML.load_file(file), options)
      end

      def from_root_hash(hash, options = {})
        from_hash_with_root_key({ root: hash }, options)
      end

      def from_hash_with_root_key(hash, options = {})
        default_options = {
          max_level:    :last,
          children_key: :children,
          root_key:     :root
        }
        options = default_options.merge(options)

        dummy_root = TreeNode.new('<TEMP>')
        real_root  = fetch_indifferently(hash, options[:root_key])

        max_level = options[:max_level]
        max_level = -2 if max_level == :last

        tree = with_children(dummy_root, [real_root], options[:children_key], max_level + 1).first_child
        tree.detached_subtree_copy
      end

      protected

      def fetch_indifferently(hash, key, default = nil)
        [key, key.to_s, key.to_s.to_sym].uniq.map { |k| hash[k] }.compact.first || default || hash.fetch(root_key)
      end

      def with_children(tree_node, children, children_key, levels_remaining)
        return tree_node if levels_remaining == 0
        children.each do |child|
          child_node     = node_from_hash(child, children_key)
          child_children = fetch_indifferently(child, children_key, [])

          tree_node << with_children(child_node, child_children, children_key, levels_remaining - 1)
        end
        tree_node
      end

      def node_from_hash(hash, children_key, options = {})
        default_options = {
          uid: SecureRandom.uuid
        }
        options = default_options.merge(options)

        name    = options[:uid]
        content = NodeContent::Factory.from_hash(hash, children_key)
        TreeNode.new(name, content)
      end

    end

  end
end
