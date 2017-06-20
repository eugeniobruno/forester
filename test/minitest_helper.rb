require 'coverage_helper'
require 'minitest/autorun'
require 'minitest/bender'
require 'pry-byebug'
require 'forester'

class Forester::Test < Minitest::Test

  private

  PATH_TO_TREES       = "#{File.dirname(__FILE__)}/trees"
  PATH_TO_SIMPLE_TREE = "#{PATH_TO_TREES}/simple_tree.yml"
  TREE = Forester::TreeFactory.from_yaml_file(PATH_TO_SIMPLE_TREE)

  BINARY_TREE = Forester::TreeFactory.node_from_hash(name: :top) do |parent|
    parent.add_child_content!(name: :left) do |left|
      left.add_child_content!(name: :left_left) do |left_left|
        left_left.add_child_content!(name: :left_left_left)
      end
      left.add_child_content!(name: :left_right)
    end
    parent.add_child_content!(name: :right) do |right|
      right.add_child_content!(name: :right_left)
      right.add_child_content!(name: :right_right)
    end
  end

  def tree
    TREE
  end

  def binary_tree
    BINARY_TREE
  end

end