require 'minitest/autorun'
require 'forester'

class TreeNodeTest < Minitest::Test

  def test_tree_node

    path_to_trees = "#{File.dirname(__FILE__)}/trees"
    tree = Forester::TreeFactory.from_yaml_file("#{path_to_trees}/simple_tree.yml")

    assert_equal 10, tree.size

    assert_equal (0..9).reduce(:+), tree.reduce(0) { |acum, node| acum + node.get('value') }

    expected_levels = [
                        ["root"],
                        ["First node of level 1", "Second node of level 1"],
                        ["First node of level 2", "Second node of level 2", "Third node of level 2"],
                        ["First node of level 3", "Second node of level 3"],
                        ["First node of level 4", "Second node of level 4"]
                      ]

    assert_equal expected_levels, tree.each_level.map { |level| level.map { |n| n.get('name') } }.to_a

    expected = {
      ["First node of level 1", "First node of level 2"]  => ["Already in level 2", "I want to be the very best", "like no one ever was"],
      ["First node of level 1", "Second node of level 2"] => ["I have a sibling to my left", "She wants to catch them all"],
      ["Second node of level 1", "Third node of level 2"] => ["Reached level 3", "It's dark", "A hidden secret lies in the deepest leaves...", "Just kidding.", "Could forester handle trees with hundreds of levels?", "Maybe."]}

    aggregation_result = tree.values_by_subtree_of_level(level: 2, aggregation_field: 'strings', include_ancestry_in_keys: true)

    assert_equal expected, aggregation_result
  end

end