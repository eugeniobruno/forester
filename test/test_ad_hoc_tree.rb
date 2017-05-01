require 'minitest_helper'

class TestAdHocTree < Forester::Test

  def test_content
    assert_equal({ number: 1 }, Forester::TreeFactory.node_from_hash(number: 1).content)
  end

  def test_each_node_type
    assert_instance_of Enumerator, binary_tree.each_node
  end

  def test_each_content_type
    assert_instance_of Enumerator, binary_tree.each_content
  end

  def test_each_content_depth_first
    expected = %i(top left left_left left_left_left left_right right right_left right_right)
    assert_equal expected, binary_tree.get(:name, subtree: true, traversal: :depth_first)
    assert_equal expected, binary_tree.each_node(traversal: :depth_first).map { |n| n.get(:name) }
    assert_equal expected, binary_tree.each_content(traversal: :depth_first).map { |c| c[:name] }
  end

  def test_each_content_breadth_first
    expected = %i(top left right left_left left_right right_left right_right left_left_left)

    assert_equal expected, binary_tree.get(:name, subtree: true, traversal: :breadth_first)
    assert_equal expected, binary_tree.each_node(traversal: :breadth_first).map { |n| n.get(:name) }
    assert_equal expected, binary_tree.each_node.map { |n| n.get(:name) }
    assert_equal expected, binary_tree.each_content(traversal: :breadth_first).map { |c| c[:name] }
    assert_equal expected, binary_tree.each_content.map { |c| c[:name] }
  end

  def test_each_content_postorder
    expected = %i(left_left_left left_left left_right left right_left right_right right top)
    assert_equal expected, binary_tree.get(:name, subtree: true, traversal: :postorder)
    assert_equal expected, binary_tree.each_node(traversal: :postorder).map { |n| n.get(:name) }
    assert_equal expected, binary_tree.each_content(traversal: :postorder).map { |c| c[:name] }
  end

  def test_each_content_preorder
    expected = %i(top left left_left left_left_left left_right right right_left right_right)
    assert_equal expected, binary_tree.get(:name, subtree: true, traversal: :preorder)
    assert_equal expected, binary_tree.each_node(traversal: :preorder).map { |n| n.get(:name) }
    assert_equal expected, binary_tree.each_content(traversal: :preorder).map { |c| c[:name] }
  end

end
