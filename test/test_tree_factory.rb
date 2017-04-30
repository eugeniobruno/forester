require 'minitest/autorun'
require 'forester'

require_relative './simple_tree_helper'

class TestTreeFactory < Minitest::Test

  include SimpleTreeHelper

  def test_from_root_hash
    hash = YAML.load_file(PATH_TO_SIMPLE_TREE)

    whole_tree = from_root_hash(hash)

    whole_trees = [whole_tree] + [29, 4].map { |ml| from_root_hash(hash, max_level: ml) }

    assert(whole_trees.product(whole_trees).all? { |t1, t2| t1.same_as?(t2) })

    pruned_trees = (0..2).map { |ml| from_root_hash(hash, max_level: ml) }

    pruned_trees.each_with_index do |t, i|
      assert_equal(i, t.max_level)

      pruned = whole_trees[i].remove_levels_past!(i)
      assert(t.same_as?(pruned))
    end
  end

  private

  def from_root_hash(hash, options = {})
    Forester::TreeFactory.from_root_hash(hash['root'], options)
  end

end
