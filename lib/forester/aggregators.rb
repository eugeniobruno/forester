module Forester
  module Aggregators

    def aggregate(config)
      Enzymator::Aggregation.new(config).run_on(self)
    end

    def values_by_subtree_of_level(options = {})
      default_options = {
        level:                    1,
        group_field:              'name',
        aggregation_field:        'value',
        if_field_missing:         lambda { |c| [] },
        include_ancestry_in_keys: false, # if false, with_root is ignored
        with_root:                false,
      }

      options = default_options.merge(options)

      Enzymator::Aggregation.new({
        null_result:       lambda { Hash.new },
        initial_clusters:  lambda { |tree| tree.nodes_of_level(options[:level]) },
        map:               lambda do |node|
                              key_nodes = if options[:include_ancestry_in_keys]
                                            node.ancestry(options[:with_root], true)
                                          else
                                            [node]
                                          end
                              key = key_nodes.map { |kn| kn.get(options[:group_field]) { |n| n.object_id } }
                              key = key.first if key.one?
                              key
                            end,
        enumerator:        lambda { |level| level.each_node },
        map_each:          lambda { |node| node.get(options[:aggregation_field], &options[:if_field_missing]) },
        reduce_each:       lambda { |acum, value| Array(acum).concat(Array(value)) },
        reduce:            lambda { |prev, group, result| prev.merge( { group => result } ) },

      }).run_on(self, options)
    end

  end
end