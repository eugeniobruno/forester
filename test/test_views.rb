require 'minitest/autorun'
require 'forester'

require_relative './simple_tree_helper'

class TestViews < Minitest::Test

  include SimpleTreeHelper

  def test_as_root_hash
    hash = (YAML.load(File.read(PATH_TO_SIMPLE_TREE)))
    add_empty_children_keys(hash['root'])

    expected = hash['root']
    actual   = @@tree.as_root_hash(stringify_keys: true)

    assert_equal expected, actual
  end

  private

  def add_empty_children_keys(hash)
    hash['children'] = hash.fetch('children', [])
    hash['children'].each { |child| add_empty_children_keys(child) }
  end

end
