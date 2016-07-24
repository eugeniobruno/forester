module Forester
  module Aggregators

    def own_and_descendants(options = {})
      default_options = {
        field: 'name',
        if_field_missing: ->(c) { [] },
      }

      options = default_options.merge(options)

      Enzymator::Aggregations::MapReduce.new(
        {
          mapping:     ->(node) { Array(node.get(options[:field], &options[:if_field_missing])) },
          #reduction:   ->(acum, values) { acum.concat(values) },
          #empty: []
          # automatically assumed
        }
      )
      .run_on(self)
    end

    def values_by_subtree_of_level(options = {})
      default_options = {
        level:                    1,
        group_field:              'name',
        aggregation_field:        'value',
        if_field_missing:         ->(c) { [] },
        include_ancestry_in_keys: false, # if false, with_root is ignored
        with_root:                false,
      }

      options = default_options.merge(options)

      input = nodes_of_level(options[:level])

      Enzymator::Aggregations::MapReduce.new({
        mapping: ->(node) {

          key_nodes = if options[:include_ancestry_in_keys]
                        node.ancestry(options[:with_root], true)
                      else
                        [node]
                      end

          key = key_nodes.map { |kn| kn.get(options[:group_field]) { |n| n.object_id } }
          key = key.first if key.one?

          value = node.own_and_descendants(
            {
              field: options[:aggregation_field],
              if_field_missing: options[:if_field_missing]
            }
          )

          { key => value }
        },
        # reduction: ->(acum, hash) { acum.merge(hash) }
        # empty: {}
        # automatically assumed
      }).run_on(input)
    end

  end
end