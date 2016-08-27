require 'minitest/autorun'
require 'forester'

require_relative './simple_tree_helper'

class TestMutators < Minitest::Test

  def setup
    path_to_trees       = "#{File.dirname(__FILE__)}/trees"
    path_to_simple_tree = "#{path_to_trees}/simple_tree.yml"
    @tree = Forester::TreeFactory.from_yaml_file(path_to_simple_tree)
  end

  def test_add_field

    @tree.add_field!('number_four', 4)

    assert_equal 4, @tree.get(:number_four)
    assert_equal 4, @tree.get('number_four')

    @tree.add_field!(:number_five, 5)

    assert_equal 5, @tree.get(:number_five)
    assert_equal 5, @tree.get('number_five')

    number_one = 1

    @tree.add_field!(:number_six, -> (node) { node.get(:number_five) + number_one })

    assert_equal 6, @tree.get(:number_six)

  end

end
