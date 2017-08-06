require 'minitest_helper'

class TestMutators < Forester::Test
  def test_add_field_in_node
    mutable_simple_tree.add_field_in_node('number_four', 4)

    assert_equal 4, mutable_simple_tree.get('number_four')

    mutable_simple_tree.add_field_in_node(:number_five, 5)

    assert_equal 5, mutable_simple_tree.get(:number_five)

    mutable_simple_tree.add_field_in_node(:number_six, -> (node) { node.get(:number_five) + 1 })

    assert_equal 6, mutable_simple_tree.get(:number_six)
  end

  def test_add_field_in_subtree
    mutable_simple_tree.add_field_in_subtree('number_four', 4)

    assert_equal 4, mutable_simple_tree[0].get('number_four')

    mutable_simple_tree.add_field_in_subtree(:number_five, 5)

    assert_equal 5, mutable_simple_tree[0].get(:number_five)

    mutable_simple_tree.add_field_in_subtree(:number_six, -> (node) { node.get(:number_five) + 1 })

    assert_equal 6, mutable_simple_tree[0].get(:number_six)
  end

  def test_add_child_content
    mutable_simple_tree.add_child_content(name: 'baby', age: 0)

    assert_equal 0, mutable_simple_tree.children.last.get(:age)
  end

  def test_delete_values
    mutable_simple_tree.delete_values_in_subtree('tags', [])
    node_1, node_2, node_3 = nodes_with_tags(mutable_simple_tree)

    assert_equal ['First tag', 'Second tag', 'Third tag'], node_1.get('tags')
    assert_equal ['Second tag', 'Third tag'],              node_2.get('tags')
    assert_equal ['Third tag'],                            node_3.get('tags')

    mutable_simple_tree.delete_values_in_subtree('tags', ['First tag'])
    node_1, node_2, node_3 = nodes_with_tags(mutable_simple_tree)

    assert_equal ['Second tag', 'Third tag'], node_1.get('tags')
    assert_equal ['Second tag', 'Third tag'], node_2.get('tags')
    assert_equal ['Third tag'],               node_3.get('tags')

    mutable_simple_tree.delete_values_in_subtree('tags', ['First tag', 'Second tag', 'Third tag'])
    node_1, node_2, node_3 = nodes_with_tags(mutable_simple_tree)

    assert_equal [], node_1.get('tags')
    assert_equal [], node_2.get('tags')
    assert_equal [], node_3.get('tags')
  end

  def test_delete_values_percolating
    mutable_simple_tree.delete_values_in_subtree('tags', ['First tag', 'Second tag', 'Third tag'], percolate: true)
    node_1, node_2, node_3 = nodes_with_tags(mutable_simple_tree)

    assert_equal ['First tag', 'Second tag', 'Third tag'], node_1.get('tags')
    assert_equal ['Second tag', 'Third tag'],              node_2.get('tags')
    assert_equal ['Third tag'],                            node_3.get('tags')

    mutable_simple_tree.delete_values_in_subtree('tags', ['First tag'], percolate: true)
    node_1, node_2, node_3 = nodes_with_tags(mutable_simple_tree)

    assert_equal ['First tag'], node_1.get('tags')
    assert_equal [],            node_2.get('tags')
    assert_equal [],            node_3.get('tags')

    mutable_simple_tree.delete_values_in_subtree('tags', [], percolate: true)
    node_1, node_2, node_3 = nodes_with_tags(mutable_simple_tree)

    assert_equal [], node_1.get('tags')
    assert_equal [], node_2.get('tags')
    assert_equal [], node_3.get('tags')
  end

  def test_change_parent_to
    node_to_move = mutable_binary_tree.find { |node| node.get('name') == 'left_left' }
    old_parent   = mutable_binary_tree.find { |node| node.get('name') == 'left' }
    new_parent   = mutable_binary_tree.find { |node| node.get('name') == 'right' }

    node_to_move.change_parent_to(new_parent)

    expected = %w[top left left_right right right_left right_right left_left left_left_left]
    assert_equal expected, mutable_binary_tree.each_node(traversal: :depth_first).map { |n| n.get('name') }

    node_to_move.change_parent_to(old_parent, subtree: false)

    expected = %w[top left left_right left_left right right_left right_right left_left_left]
    assert_equal expected, mutable_binary_tree.each_node(traversal: :depth_first).map { |n| n.get('name') }
  end

  def test_remove_levels_past0
    assert_raises(ArgumentError) { mutable_simple_tree.remove_levels_past(0) }
  end

  def test_remove_levels_past1
    mutable_simple_tree.remove_levels_past(1)
    assert_equal 1, mutable_simple_tree.size
  end

  def test_remove_levels_past2
    mutable_simple_tree.remove_levels_past(2)
    assert_equal 3, mutable_simple_tree.size
  end

  def test_remove_levels_past3
    mutable_simple_tree.remove_levels_past(3)
    assert_equal 6, mutable_simple_tree.size
  end

  def test_remove_levels_past4
    mutable_simple_tree.remove_levels_past(4)
    assert_equal 8, mutable_simple_tree.size
  end

  def test_remove_levels_past5
    mutable_simple_tree.remove_levels_past(5)
    assert_equal 10, mutable_simple_tree.size
  end

  def test_remove_levels_past6
    mutable_simple_tree.remove_levels_past(6)
    assert_equal 10, mutable_simple_tree.size
  end

  private

  def mutable_simple_tree
    @mutable_simple_tree ||= simple_tree.detached_subtree_copy
  end

  def mutable_binary_tree
    @mutable_binary_tree ||= binary_tree.detached_subtree_copy
  end

  def nodes_with_tags(tree)
    tree.select { |node| node.has_field?('tags') }
  end
end
