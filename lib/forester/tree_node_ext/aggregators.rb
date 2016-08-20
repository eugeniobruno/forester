module Forester
  module Aggregators

    def nodes_with(content_key, content_values)
      each_node.select { |node| not ( Array(node.get(content_key) { :no_match }) & Array(content_values) ).empty? }
    end

    def with_ancestry(options = {})
      default_options = {
        include_root: true,
        include_self: true,
        descending: true
      }
      options = default_options.merge(options)

      ancestors = self.parentage           || []
      ancestors = ancestors[0...-1]        unless options[:include_root]
      ancestors = ancestors.unshift(self)  if     options[:include_self]
      if options[:descending] then ancestors.reverse else ancestors end
    end

    def own_and_descendants(field_name, &if_field_missing)
      if_field_missing = -> (node) { [] } unless block_given?
      flat_map do |node|
        Array(node.get(field_name, &if_field_missing))
      end
    end

    def search(options)
      default_options = {
        single_node: true,
        by_field:    :name,
        keywords:    :missing_search_keywords,
        then_get:    :nodes,
        of_subtree:  true,
      }
      options = default_options.merge(options)

      found_nodes = nodes_with(options[:by_field], options[:keywords])

      found_nodes = found_nodes.slice(0, 1) if options[:single_node]

      return found_nodes if options[:then_get] == :nodes

      found_nodes.flat_map do |node|
        if options[:of_subtree]
          node.own_and_descendants(options[:then_get])
        else
          node.get(options[:then_get])
        end
      end

    end

    def values_by_subtree_of_level(options = {})
      default_options = {
        level:                    1,
        group_field:              'name',
        aggregation_field:        'value',
        if_field_missing:         -> (node) { [] },
        include_ancestry_in_keys: false, # if false, with_root is ignored
        with_root:                false,
      }
      options = default_options.merge(options)

      nodes_of_level(options[:level]).each_with_object({}) do |node, hash|

        key_nodes = if options[:include_ancestry_in_keys]
                      node.with_ancestry({ include_root: options[:with_root] })
                    else
                      node
                    end

        key = key_nodes.map { |kn| kn.get(options[:group_field]) { |n| n.object_id } }
        value = node.own_and_descendants(options[:aggregation_field], &options[:if_field_missing])

        hash[key] = value
      end
    end

  end
end