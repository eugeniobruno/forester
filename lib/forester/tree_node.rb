module Forester
  class TreeNode < Tree::TreeNode

    extend Forwardable
    def_delegators :@content, :fields, :has?, :put!, :add!, :del!

    include Aggregators
    include Mutators
    include Views

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

    alias_method :each_node, :breadth_each

    def get(field, default = :raise_error, &block)
      if has?(field)
        content.get(field)
      elsif block_given?
        yield self
      elsif default != :raise_error
        default
      else
        raise ArgumentError.new("the node \"#{name}\" does not have \"#{field}\"")
      end
    end

    def name
      content.get(:name, super)
    end

    def contents
      each_node.map(&:content)
    end

  end
end
