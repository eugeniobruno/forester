require 'minitest_helper'

class TestAdHocTree < Forester::Test

  def test_content
    assert_equal 1, Forester::TreeFactory.node(1).content
  end

  def test_each_content_type
    assert_instance_of Enumerator, binary_tree.each_content
  end

  def test_each_content_depth_first
    expected = %i(top left left_left left_left_left left_right right right_left right_right)
    assert_equal expected, binary_tree.each_content(traversal: :depth_first).to_a
  end

  def test_each_content_breadth_first
    expected = %i(top left right left_left left_right right_left right_right left_left_left)
    assert_equal expected, binary_tree.each_content(traversal: :breadth_first).to_a
    assert_equal expected, binary_tree.each_content.to_a
  end

  def test_each_content_postorder
    expected = %i(left_left_left left_left left_right left right_left right_right right top)
    assert_equal expected, binary_tree.each_content(traversal: :postorder).to_a
  end

  def test_each_content_preorder
    expected = %i(top left left_left left_left_left left_right right right_left right_right)
    assert_equal expected, binary_tree.each_content(traversal: :preorder).to_a
  end

  private

  def binary_tree
    @binary_tree ||= begin
      Forester::TreeFactory.node(:top) do |parent|
        parent.add_child_content!(:left) do |left|
          left.add_child_content!(:left_left) do |left_left|
            left_left.add_child_content!(:left_left_left)
          end
          left.add_child_content!(:left_right)
        end
        parent.add_child_content!(:right) do |right|
          right.add_child_content!(:right_left)
          right.add_child_content!(:right_right)
        end
      end
    end
  end

end
