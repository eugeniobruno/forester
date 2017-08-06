require 'minitest_helper'

class TestIterators < Forester::Test
  def test_each_node_type
    assert_instance_of Enumerator, binary_tree.each_node
  end

  def test_each_content_type
    assert_instance_of Enumerator, binary_tree.each_content
  end

  def test_each_content_depth_first
    expected = %w[top left left_left left_left_left left_right right right_left right_right]

    assert_equal expected, binary_tree.each_node.map { |n| n.get('name') }
    assert_equal expected, binary_tree.each_node(traversal: :depth_first).map { |n| n.get('name') }
    assert_equal expected, binary_tree.each_content(traversal: :depth_first).map { |c| c['name'] }
  end

  def test_each_content_breadth_first
    expected = %w[top left right left_left left_right right_left right_right left_left_left]

    assert_equal expected, binary_tree.each_node(traversal: :breadth_first).map { |n| n.get('name') }
    assert_equal expected, binary_tree.each_content(traversal: :breadth_first).map { |c| c['name'] }
  end

  def test_each_content_postorder
    expected = %w[left_left_left left_left left_right left right_left right_right right top]

    assert_equal expected, binary_tree.each_node(traversal: :postorder).map { |n| n.get('name') }
    assert_equal expected, binary_tree.each_content(traversal: :postorder).map { |c| c['name'] }
  end

  def test_each_content_preorder
    expected = %w[top left left_left left_left_left left_right right right_left right_right]

    assert_equal expected, binary_tree.each_node(traversal: :preorder).map { |n| n.get('name') }
    assert_equal expected, binary_tree.each_content(traversal: :preorder).map { |c| c['name'] }
  end

  def test_each_level
    expected  = [
      ["root"],
      ["First node of depth 1", "Second node of depth 1"],
      ["First node of depth 2", "Second node of depth 2", "Third node of depth 2"],
      ["First node of depth 3", "Second node of depth 3"],
      ["First node of depth 4", "Second node of depth 4"]
    ]

    actual = simple_tree.each_level.map { |l| l.map { |n| n.get('name') } }

    assert_equal expected, actual
  end

  def test_invalid_traversal_mode
    assert_raises(ArgumentError) do
      binary_tree.each_node(traversal: :foo)
    end
  end
end
