require 'minitest/autorun'
require 'forester'

class TestTreeNode < Minitest::Test

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


    expected_value = [7]
    actual_value = tree.values_by_field({
      field_to_search: 'name',
      search_keyword: 'Second node of level 3',
      values_key: 'value'
    })
    assert_equal expected_value, actual_value

    expected_values = [7, 8, 9]
    actual_values = tree.values_by_field({
      field_to_search: 'name',
      search_keyword: 'Second node of level 3',
      values_key: 'value',
      include_descendants: true
    })
    assert_equal expected_values, actual_values

    expected_value = [7]
    actual_value = tree.values_by_field({
      field_to_search: 'strings',
      search_keyword: 'A hidden secret lies in the deepest leaves...',
      values_key: 'value'
    })
    assert_equal expected_value, actual_value


    expected_names = ["A hidden secret lies in the deepest leaves...", "Just kidding.", "Could forester handle trees with hundreds of levels?", "Maybe."]

    found_nodes = tree.nodes_with('name', 'Second node of level 3')
    assert_equal 1, found_nodes.length

    actual_names = found_nodes.flat_map do |node|
      node.own_and_descendants('strings')
    end

    assert_equal expected_names, actual_names
  end

end