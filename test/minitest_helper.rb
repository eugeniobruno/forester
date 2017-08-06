require 'coverage_helper'
require 'minitest/autorun'
require 'minitest/bender'
require 'pry-byebug'
require 'forester'

module Forester
  class Test < Minitest::Test
    private

    def simple_tree_hash
      @simple_tree ||= begin
        load_tree('simple')
      end
    end

    def simple_tree
      Forester.tree_factory.from_root_hash(simple_tree_hash, children_key: 'children')
    end

    def binary_tree_hash
      @binary_tree ||= load_tree('binary')
    end

    def binary_tree
      Forester.tree_factory.from_root_hash(binary_tree_hash, children_key: 'children')
    end

    def load_tree(name)
      path_to_trees = "#{File.dirname(__FILE__)}/trees"
      path_to_tree  = "#{path_to_trees}/#{name}_tree.yml"
      YAML.load_file(path_to_tree).fetch('root')
    end
  end
end
