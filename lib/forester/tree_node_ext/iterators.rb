module Forester
  module Iterators
    TRAVERSAL_MODES = {
      depth_first: :each,
      breadth_first: :breadth_each,
      preorder: :preordered_each,
      postorder: :postordered_each
    }.freeze

    def each_node(options = {}, &block)
      default_options = {
        traversal: :depth_first
      }
      options = default_options.merge(options)

      method_name = traversal_modes[options[:traversal]]

      if method_name
        send(method_name, &block)
      else
        available = traversal_modes.keys.join(', ')
        raise ArgumentError, "invalid traversal mode: #{options[:traversal]} (#{available})"
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

    private

    def traversal_modes
      TRAVERSAL_MODES
    end
  end
end
