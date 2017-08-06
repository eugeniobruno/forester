require 'minitest_helper'

class TestTreeFactory < Forester::Test
  def test_from_root_hash
    whole_tree = from_root_hash(simple_tree_hash)

    assert_equal 10, whole_tree.size
  end

  def test_from_root_hash_with_max_depth
    pruned_tree = from_root_hash(simple_tree_hash, max_depth: 2)

    assert_equal 6, pruned_tree.size
  end

  def test_node_from_content
    assert_equal({ number: 1 }, Forester.tree_factory.node_from_content(number: 1).content)
  end

  private

  def from_root_hash(root_hash, options = {})
    Forester.tree_factory.from_root_hash(root_hash, options.merge(children_key: 'children'))
  end
end
