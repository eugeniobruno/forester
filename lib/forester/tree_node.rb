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
      Enumerator.new do |yielder|
        level = [self]
        begin
          yielder << level
          level = level.flat_map(&:children)
        end until level.empty?
      end
    end

    def values_by_field(options)
      default_options = {
        field_to_search: 'name',
        search_keyword: :missing_search_keyword,
        values_key: :missing_values_key,
        include_descendants: false,
        assume_uniqueness: false
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

    def nodes_with(content_key, content_value)
      each_node.select { |node| Array(node.get(content_key) { :no_match }).include? content_value }
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
