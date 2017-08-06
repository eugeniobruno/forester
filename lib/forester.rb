require 'forester/version'

require 'securerandom'

require 'tree'

require 'forester/tree_node_ext/iterators'
require 'forester/tree_node_ext/mutators'
require 'forester/tree_node_ext/validators'
require 'forester/tree_node_ext/serializers'

require 'forester/tree_node'
require 'forester/tree_factory'

module Forester
  def self.tree_factory
    @tree_factory ||= TreeFactory.new
  end
end
