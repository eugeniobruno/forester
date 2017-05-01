module Forester
  module Aggregators

    def own_and_descendants(field, options = {}, &if_missing)
      default_options = {
        traversal: :depth_first
      }
      options = default_options.merge(options)

      if_missing = -> (node) { [] } unless block_given?

      each_node(traversal: options[:traversal]).flat_map do |node|
        as_array(node.get(field, &if_missing))
      end
    end

    def nodes_with(field, values, options = {})
      default_options = {
        single: false
      }
      options = default_options.merge(options)

      method = options[:single] ? :find : :select
      found_nodes = each_node.public_send(method) do |node|
        not ( as_array(node.get(field) { :no_match }) & as_array(values) ).empty?
      end

      as_array(found_nodes)
    end

    def with_ancestry(options = {})
      default_options = {
        include_root: true,
        include_self: true,
        descending:   true
      }
      options = default_options.merge(options)

      ancestors = self.parentage          || []
      ancestors = ancestors[0...-1]       unless options[:include_root]
      ancestors = ancestors.unshift(self) if     options[:include_self]

      options[:descending] ? ancestors.reverse : ancestors
    end

    def search(options)
      default_options = {
        single_node: false,
        by_field:    :name,
        keywords:    :missing_search_keywords,
        then_get:    :nodes, # if :nodes, subtree is ignored
        subtree:     true
      }
      options = default_options.merge(options)

      found_nodes = nodes_with(options[:by_field], options[:keywords], single: options[:single_node] )

      return found_nodes if options[:then_get] == :nodes
      # TODO this method should never return [nil]. This happens when single_node
      # is true and no matches are found. Moreover, if then_get is not :nodes,
      # it should not raise. Both cases should return [].

      found_nodes.flat_map do |node|
        node.get(options[:then_get], subtree: options[:subtree])
      end
    end

    def group_by_sibling_subtrees(options = {})
      default_options = {
        level:             1,
        group_field:       'name',
        aggregation_field: 'value',
        if_field_missing:  -> (node) { [] },
        ancestry_in_keys:  false, # if false, with_root is ignored
        with_root:         false
      }
      options = default_options.merge(options)

      nodes_of_level(options[:level]).each_with_object({}) do |node, hash|
        key =
          if options[:ancestry_in_keys]
            nodes_for_key = node.with_ancestry(include_root: options[:with_root])
            nodes_for_key.map { |n| get_or_id(n, options[:group_field]) }
          else
            get_or_id(node, options[:group_field])
          end

        value = node.own_and_descendants(options[:aggregation_field], &options[:if_field_missing])

        hash[key] = value
      end
    end

    private

    def get_or_id(node, field)
      node.get(field) { |n| n.object_id }
    end

  end
end
