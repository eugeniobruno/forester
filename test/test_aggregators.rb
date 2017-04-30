require 'minitest_helper'

class TestAggregators < Forester::Test

  def test_group_by_sibling_subtrees

    expected = {
      "First node of level 2"  => ["Already in level 2", "I want to be the very best", "like no one ever was"],
      "Second node of level 2" => ["I have a sibling to my left", "She wants to catch them all"],
      "Third node of level 2"  => ["Reached level 3", "It's dark", "A hidden secret lies in the deepest leaves...", "Just kidding.", "Could forester handle trees with hundreds of levels?", "Maybe."]
    }

    actual = tree.group_by_sibling_subtrees(
      level: 2,
      aggregation_field: 'strings'
    )

    assert_equal expected, actual
  end

  def test_group_by_sibling_subtrees_with_ancestry

    expected = {
      ["First node of level 1", "First node of level 2"]  => ["Already in level 2", "I want to be the very best", "like no one ever was"],
      ["First node of level 1", "Second node of level 2"] => ["I have a sibling to my left", "She wants to catch them all"],
      ["Second node of level 1", "Third node of level 2"] => ["Reached level 3", "It's dark", "A hidden secret lies in the deepest leaves...", "Just kidding.", "Could forester handle trees with hundreds of levels?", "Maybe."]
    }

    actual = tree.group_by_sibling_subtrees(
      level: 2,
      aggregation_field: 'strings',
      ancestry_in_keys: true
    )

    assert_equal expected, actual
  end

  def test_nodes_with
    expected_names = ["A hidden secret lies in the deepest leaves...", "Just kidding.", "Could forester handle trees with hundreds of levels?", "Maybe."]

    found_nodes = tree.nodes_with('name', 'Second node of level 3')
    assert_equal 1, found_nodes.length

    actual_names = found_nodes.flat_map do |node|
      node.own_and_descendants('strings')
    end

    assert_equal expected_names, actual_names
  end

  def test_search

    expected = [7]

    actual_1 = tree.search({
      by_field: 'name',
      keywords: 'Second node of level 3',
      then_get: 'value',
      subtree:  false
    })

    actual_2 = tree.search({
      by_field: 'name',
      keywords: ['Second node of level 3', 'Not present name'],
      then_get: 'value',
      subtree:  false
    })

    actual_3 = tree.search({
      by_field: 'strings',
      keywords: 'A hidden secret lies in the deepest leaves...',
      then_get: 'value',
      subtree:  false
    })
    assert_equal expected, actual_1
    assert_equal expected, actual_2
    assert_equal expected, actual_3

    expected_values = [7, 8, 9]
    actual_values = tree.search({
      by_field: 'name',
      keywords: 'Second node of level 3',
      then_get: 'value',
      subtree:  true
    })
    assert_equal expected_values, actual_values
  end

end
