require 'minitest_helper'

class TestTreeNode < Forester::Test

  def test_size
    assert_equal 10, tree.size
  end

  def test_values
    values = (0..9).to_a

    expected = values.reduce(:+)
    actual   = tree.reduce(0) { |acum, node| acum + node.get('value') }

    assert_equal expected, actual

    assert_equal values, tree.get('value', subtree: true)
  end

  def test_missing_values
    assert_equal 0,    tree.get('value')
    assert_equal 'no', tree.get('whatever', default: 'no')
    assert_equal 'no', tree.get('whatever', default: 'missing') { 'no' }
    assert_equal 'no', tree.get('whatever') { 'no' }
    assert_equal 'no', tree.get('whatever') { |n| 'no' }
    assert_equal 1,    tree.get('whatever') { |n| n.get('value') + 1 }
  end

  def test_levels
    expected  = [
                  ["root"],
                  ["First node of level 1", "Second node of level 1"],
                  ["First node of level 2", "Second node of level 2", "Third node of level 2"],
                  ["First node of level 3", "Second node of level 3"],
                  ["First node of level 4", "Second node of level 4"]
                ]
    actual    = tree.each_level.map { |l| l.map { |n| n.get('name') } }.to_a

    assert_equal expected, actual
  end

end
