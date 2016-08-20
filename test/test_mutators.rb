require 'minitest/autorun'
require 'forester'

class TestMutators < Minitest::Test

  def test_mutators

    path_to_trees = "#{File.dirname(__FILE__)}/trees"
    tree = Forester::TreeFactory.from_yaml_file("#{path_to_trees}/simple_tree.yml")

    tree.add_field_to_subtree!('number_four', 4)

    assert_equal 4, tree.get(:number_four)
    assert_equal 4, tree.get('number_four')

    tree.add_field_to_subtree!(:number_five, 5)

    assert_equal 5, tree.get(:number_five)
    assert_equal 5, tree.get('number_five')

    number_one = 1

    tree.add_field_to_subtree!(:number_six, -> (node) { node.get(:number_five) + number_one })

    assert_equal 6, tree.get(:number_six)

  end

end