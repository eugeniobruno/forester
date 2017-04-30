require 'minitest_helper'

class TestMutators < Forester::Test

  def setup
    @mutable_tree = Forester::TreeFactory.from_yaml_file(PATH_TO_SIMPLE_TREE)
  end

  def test_add_field
    tree.add_field!('number_four', 4)

    assert_equal 4, tree.get(:number_four)
    assert_equal 4, tree.get('number_four')

    tree.add_field!(:number_five, 5)

    assert_equal 5, tree.get(:number_five)
    assert_equal 5, tree.get('number_five')

    number_one = 1

    tree.add_field!(:number_six, -> (node) { node.get(:number_five) + number_one })

    assert_equal 6, tree.get(:number_six)
  end

  def test_delete_values
    node_1, node_2, node_3 = nodes_with_tags

    tree.delete_values!(:tags, [])
    assert_equal ['First tag', 'Second tag', 'Third tag'], node_1.get(:tags)
    assert_equal ['Second tag', 'Third tag'],              node_2.get(:tags)
    assert_equal ['Third tag'],                            node_3.get(:tags)

    tree.delete_values!(:tags, ['First tag'])
    assert_equal ['Second tag', 'Third tag'], node_1.get(:tags)
    assert_equal ['Second tag', 'Third tag'], node_2.get(:tags)
    assert_equal ['Third tag'],               node_3.get(:tags)

    tree.delete_values!(:tags, ['First tag', 'Second tag', 'Third tag'])
    assert_equal [], node_1.get(:tags)
    assert_equal [], node_2.get(:tags)
    assert_equal [], node_3.get(:tags)
  end

  def test_percolate_values
    node_1, node_2, node_3 = nodes_with_tags

    tree.percolate_values!(:tags, ['First tag', 'Second tag', 'Third tag'])
    assert_equal ['First tag', 'Second tag', 'Third tag'], node_1.get(:tags)
    assert_equal ['Second tag', 'Third tag'],              node_2.get(:tags)
    assert_equal ['Third tag'],                            node_3.get(:tags)

    tree.percolate_values!(:tags, ['First tag'])
    assert_equal ['First tag'], node_1.get(:tags)
    assert_equal [],            node_2.get(:tags)
    assert_equal [],            node_3.get(:tags)

    tree.percolate_values!(:tags, [])
    assert_equal [], node_1.get(:tags)
    assert_equal [], node_2.get(:tags)
    assert_equal [], node_3.get(:tags)
  end

  private

  def tree
    @mutable_tree
  end

  def nodes_with_tags
    [1, 6, 9].map do |n|
      tree.search({
        single_node: true,
        by_field: :value,
        keywords: n
      }).first
    end
  end

end
