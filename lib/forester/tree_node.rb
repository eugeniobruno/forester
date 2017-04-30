module Forester
  class TreeNode < Tree::TreeNode

    extend Forwardable
    def_delegators :@content, :fields, :has?, :put!, :add!, :del!

    include Aggregators
    include Validators
    include Mutators
    include Views

    alias_method :max_level, :node_height

    def nodes_of_level(l)
      l.between?(0, max_level) ? each_level.take(l + 1).last : []
    end

    def each_node(options = {})
      default_options = {
        traversal: :breadth_first
      }
      options = default_options.merge(options)

      case options[:traversal]
      when :breadth_first
        breadth_each
      when :depth_first
        each
      when :postorder
        postordered_each
      when :preorder
        preordered_each
      else
        raise ArgumentError, "invalid traversal mode: #{options[:traversal]}"
      end
    end

    def each_content(options = {})
      node_enumerator = each_node(options)

      Enumerator.new do |yielder|
        stop = false
        until stop
          begin
            yielder << node_enumerator.next.content
          rescue StopIteration
            stop = true
          end
        end
      end
    end

    def each_level
      Enumerator.new do |yielder|
        level = [self]
        until level.empty?
          yielder << level
          level = level.flat_map(&:children)
        end
      end
    end

    def get(field, options = {}, &if_missing)
      default_options = {
        default: :raise,
        subtree: false
      }
      options = default_options.merge(options)

      return own_and_descendants(field, &if_missing) if options[:subtree]

      if has?(field)
        content.get(field)
      elsif block_given?
        yield self
      elsif options[:default] != :raise
        options[:default]
      else
        raise ArgumentError.new("the node \"#{name}\" does not have \"#{field}\"")
      end
    end

    def contents
      each_node.map(&:content)
    end

    def same_as?(other)
      return false unless content == other.content
      return false unless    size == other.size
      nodes_of_other = other.each_node.to_a
      each_node.with_index do |n, i|
        next if i == 0
        return false unless n.same_as?(nodes_of_other[i])
      end
      true
    end

    private

    def as_array(object)
      [object].flatten(1)
    end

  end
end
