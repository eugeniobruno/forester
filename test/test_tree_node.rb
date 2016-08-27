require 'minitest/autorun'
require 'forester'

require_relative './simple_tree_helper'

class TestTreeNode < Minitest::Test

  include SimpleTreeHelper

  def test_size
    assert_equal 10, @@tree.size
  end

  def test_values
    expected = (0..9).reduce(:+)
    actual   = @@tree.reduce(0) { |acum, node| acum + node.get('value') }

    assert_equal expected, actual
  end

  def test_levels
    expected  = [
                  ["root"],
                  ["First node of level 1", "Second node of level 1"],
                  ["First node of level 2", "Second node of level 2", "Third node of level 2"],
                  ["First node of level 3", "Second node of level 3"],
                  ["First node of level 4", "Second node of level 4"]
                ]
    actual    = @@tree.each_level.map { |l| l.map { |n| n.get('name') } }.to_a

    assert_equal expected, actual
  end

end