module Forester
  module Aggregators

    def own_and_descendants(options = {})
      default_options = {
        field: 'name',
        if_field_missing: -> (c) { [] },
      }

      options = default_options.merge(options)

      flat_map do |node|
        Array(node.get(options[:field], &options[:if_field_missing]))
      end
    end

    def values_by_field(options)
      default_options = {
        field_to_search:     'name',
        search_keyword:      :missing_search_keyword,
        values_key:          :missing_values_key,
        include_descendants: false,
        assume_uniqueness:   false
      }
      options = default_options.merge(options)

      found_nodes = nodes_with(options[:field_to_search], options[:search_keyword])

      # When assuming that node names are unique,
      # if more than one node was found,
      # discard all but the first one
      found_nodes = found_nodes.slice(0, 1) if options[:assume_uniqueness]

      found_nodes.flat_map do |node|
        if options[:include_descendants]
          node.own_and_descendants({ field: options[:values_key] })
        else
          node.get(options[:values_key])
        end
      end

    end

    def values_by_subtree_of_level(options = {})
      default_options = {
        level:                    1,
        group_field:              'name',
        aggregation_field:        'value',
        if_field_missing:         -> (c) { [] },
        include_ancestry_in_keys: false, # if false, with_root is ignored
        with_root:                false,
      }

      options = default_options.merge(options)

      nodes_of_level(options[:level]).each_with_object({}) do |node, hash|

        key_nodes = if options[:include_ancestry_in_keys]
                      node.ancestry(options[:with_root], true)
                    else
                      node
                    end

        key = key_nodes.map { |kn| kn.get(options[:group_field]) { |n| n.object_id } }

        value = node.own_and_descendants(
          {
            field: options[:aggregation_field],
            if_field_missing: options[:if_field_missing]
          }
        )

        hash[key] = value
      end
    end

  end
end