require 'minitest_helper'

class TestTreeNode < Forester::Test
  def test_node_level
    # the root is in level 1 and has depth 0
    assert_equal 1, simple_tree.node_level
     # the first child of the root is in level 2 and has depth 1
    assert_equal 2, simple_tree[0].node_level
  end

  def test_nodes_of_depth0
    expected = ['root']
    actual = simple_tree.nodes_of_depth(0).map { |n| n.get('name') }

    assert_equal expected, actual
  end

  def test_nodes_of_depth1
    expected = [1, 4]
    actual = simple_tree.nodes_of_depth(1).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_nodes_of_depth2
    expected = [2, 3, 5]
    actual = simple_tree.nodes_of_depth(2).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_nodes_of_level0
    expected = []
    actual = simple_tree.nodes_of_level(0)

    assert_equal expected, actual
  end

  def test_nodes_of_level1
    expected = ['root']
    actual = simple_tree.nodes_of_level(1).map { |n| n.get('name') }

    assert_equal expected, actual
  end

  def test_nodes_of_level2
    expected = [1, 4]
    actual = simple_tree.nodes_of_level(2).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_path_from_root
    assert_equal ['root'],  simple_tree.path_from_root.map { |n| n.get('name') }
    assert_equal [0, 1],    simple_tree[0].path_from_root.map { |n| n.get('value') }
    assert_equal [0, 1, 2], simple_tree[0][0].path_from_root.map { |n| n.get('value') }
    assert_equal [0, 1, 3], simple_tree[0][1].path_from_root.map { |n| n.get('value') }
  end

  def test_leaves
    assert_equal [2, 3, 6, 8, 9], simple_tree.leaves.map { |n| n.get('value') }
  end

  def test_paths_to_leaves
    expected = [
      [0, 1, 2],
      [0, 1, 3],
      [0, 4, 5, 6],
      [0, 4, 5, 7, 8],
      [0, 4, 5, 7, 9]
    ]

    actual = simple_tree.paths_to_leaves.map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_of_length0
    expected = [
      [0]
    ]

    actual = simple_tree.paths_of_length(0).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_of_length1
    expected = [
      [0, 1],
      [0, 4]
    ]

    actual = simple_tree.paths_of_length(1).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_of_length2
    expected = [
      [0, 1, 2],
      [0, 1, 3],
      [0, 4, 5] # even though 5 is not a leaf
    ]

    actual = simple_tree.paths_of_length(2).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_of_length3
    expected = [
      [0, 4, 5, 6],
      [0, 4, 5, 7] # even though 7 is not a leaf
    ]

    actual = simple_tree.paths_of_length(3).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_of_length4
    expected = [
      [0, 4, 5, 7, 8],
      [0, 4, 5, 7, 9]
    ]

    actual = simple_tree.paths_of_length(4).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_of_length5
    expected = []

    actual = simple_tree.paths_of_length(5).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_leaves_when_pruned_to_depth0
    expected = [0]

    actual = simple_tree.leaves_when_pruned_to_depth(0).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_leaves_when_pruned_to_depth1
    expected = [1, 4]

    actual = simple_tree.leaves_when_pruned_to_depth(1).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_leaves_when_pruned_to_depth2
    expected = [2, 3, 5]

    actual = simple_tree.leaves_when_pruned_to_depth(2).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_leaves_when_pruned_to_depth3
    expected = [2, 3, 6, 7]

    actual = simple_tree.leaves_when_pruned_to_depth(3).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_leaves_when_pruned_to_depth4
    expected = [2, 3, 6, 8, 9] # all leaves, since 4 is the max depth

    actual = simple_tree.leaves_when_pruned_to_depth(4).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_leaves_when_pruned_to_depth5
    expected = [2, 3, 6, 8, 9] # all leaves, since 4 is the max depth

    actual = simple_tree.leaves_when_pruned_to_depth(5).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_leaves_when_pruned_to_level0
    expected = []

    actual = simple_tree.leaves_when_pruned_to_level(0).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_leaves_when_pruned_to_level1
    expected = [0]

    actual = simple_tree.leaves_when_pruned_to_level(1).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_leaves_when_pruned_to_level2
    expected = [1, 4]

    actual = simple_tree.leaves_when_pruned_to_level(2).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_leaves_when_pruned_to_level3
    expected = [2, 3, 5]

    actual = simple_tree.leaves_when_pruned_to_level(3).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_leaves_when_pruned_to_level4
    expected = [2, 3, 6, 7]

    actual = simple_tree.leaves_when_pruned_to_level(4).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_leaves_when_pruned_to_level5
    expected = [2, 3, 6, 8, 9]

    actual = simple_tree.leaves_when_pruned_to_level(5).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_leaves_when_pruned_to_level6
    expected = [2, 3, 6, 8, 9]

    actual = simple_tree.leaves_when_pruned_to_level(6).map { |n| n.get('value') }

    assert_equal expected, actual
  end

  def test_paths_to_leaves_when_pruned_to_depth0
    expected = [
      [0]
    ]

    actual = simple_tree.paths_to_leaves_when_pruned_to_depth(0).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_to_leaves_when_pruned_to_depth1
    expected = [
      [0, 1],
      [0, 4]
    ]

    actual = simple_tree.paths_to_leaves_when_pruned_to_depth(1).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_to_leaves_when_pruned_to_depth2
    expected = [
      [0, 1, 2],
      [0, 1, 3],
      [0, 4, 5]
    ]

    actual = simple_tree.paths_to_leaves_when_pruned_to_depth(2).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_to_leaves_when_pruned_to_depth3
    expected = [
      [0, 1, 2],
      [0, 1, 3],
      [0, 4, 5, 6],
      [0, 4, 5, 7]
    ]

    actual = simple_tree.paths_to_leaves_when_pruned_to_depth(3).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_to_leaves_when_pruned_to_depth4
    expected = [
      [0, 1, 2],
      [0, 1, 3],
      [0, 4, 5, 6],
      [0, 4, 5, 7, 8],
      [0, 4, 5, 7, 9],
    ]

    actual = simple_tree.paths_to_leaves_when_pruned_to_depth(4).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_to_leaves_when_pruned_to_depth5
    expected = [
      [0, 1, 2],
      [0, 1, 3],
      [0, 4, 5, 6],
      [0, 4, 5, 7, 8],
      [0, 4, 5, 7, 9],
    ]

    actual = simple_tree.paths_to_leaves_when_pruned_to_depth(5).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_to_leaves_when_pruned_to_level0
    expected = []

    actual = simple_tree.paths_to_leaves_when_pruned_to_level(0).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_to_leaves_when_pruned_to_level1
    expected = [
      [0]
    ]

    actual = simple_tree.paths_to_leaves_when_pruned_to_level(1).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_to_leaves_when_pruned_to_level2
    expected = [
      [0, 1],
      [0, 4]
    ]

    actual = simple_tree.paths_to_leaves_when_pruned_to_level(2).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_to_leaves_when_pruned_to_level3
    expected = [
      [0, 1, 2],
      [0, 1, 3],
      [0, 4, 5]
    ]

    actual = simple_tree.paths_to_leaves_when_pruned_to_level(3).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_to_leaves_when_pruned_to_level4
    expected = [
      [0, 1, 2],
      [0, 1, 3],
      [0, 4, 5, 6],
      [0, 4, 5, 7]
    ]

    actual = simple_tree.paths_to_leaves_when_pruned_to_level(4).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_to_leaves_when_pruned_to_level5
    expected = [
      [0, 1, 2],
      [0, 1, 3],
      [0, 4, 5, 6],
      [0, 4, 5, 7, 8],
      [0, 4, 5, 7, 9],
    ]

    actual = simple_tree.paths_to_leaves_when_pruned_to_level(5).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_paths_to_leaves_when_pruned_to_level6
    expected = [
      [0, 1, 2],
      [0, 1, 3],
      [0, 4, 5, 6],
      [0, 4, 5, 7, 8],
      [0, 4, 5, 7, 9],
    ]

    actual = simple_tree.paths_to_leaves_when_pruned_to_level(6).map { |path| path.map { |n| n.get('value') } }

    assert_equal expected, actual
  end

  def test_get
    assert_equal 0,     simple_tree.get('value')
    assert_equal 'no',  simple_tree.get('any', 'no')
    assert_equal 'no',  simple_tree.get('any', 'missing') { 'no' }
    assert_equal 'no',  simple_tree.get('any') { 'no' }
    assert_equal 'any', simple_tree.get('any') { |field| field }
    assert_equal 1,     simple_tree.get('any') { |_field, node| node.get('value') + 1 }

    assert_raises(KeyError) { simple_tree.get('any') }
    assert_raises(KeyError) { simple_tree.get(:any) }
    assert_raises(KeyError) { simple_tree.get(42) }
  end
end
