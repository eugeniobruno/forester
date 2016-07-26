module Forester
  class TreeNode < Tree::TreeNode

    include Aggregators
    include Mutators
    include Views

    def ancestry(include_root = true, include_self = false, descending = true)
      ancestors = self.parentage           || []
      ancestors = ancestors[0...-1]        unless include_root
      ancestors = ancestors.unshift(self)  if     include_self
      if descending then ancestors.reverse else ancestors end
    end

    def nodes_of_level(l)
      if l.between?(0, max_level) then each_level.take(l + 1).last else [] end
    end

    alias_method :max_level, :node_height

    def each_level
      Enumerator.new do |yielder|
        level = [self]
        begin
          yielder << level
          level = level.flat_map(&:children)
        end until level.empty?
      end
    end

    def nodes_with(content_key, content_value)
      each_node.select { |node| Array(node.get(content_key) { :no_match }).include? content_value }
    end

    alias_method :each_node, :breadth_each

    def get(field, &block)
      content.public_send(field, &block)
    end

    def field_names
      content.field_names
    end

    def contents
      each_node.map(&:content)
    end

  end
end
