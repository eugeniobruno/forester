require 'minitest/autorun'
require 'forester'

class TestViews < Minitest::Test

  def test_views

    path_to_trees = "#{File.dirname(__FILE__)}/trees"
    tree = Forester::TreeFactory.from_yaml_file("#{path_to_trees}/simple_tree.yml")

    hash = (YAML.load(File.read("#{path_to_trees}/simple_tree.yml")))
    add_empty_children_keys(hash['root'])

    assert_equal hash['root'], tree.as_nested_hash({ stringify_keys: true })

  end

  private

  def add_empty_children_keys(hash)
    hash['children'] = hash.fetch('children', [])
    hash['children'].each { |child| add_empty_children_keys(child) }
  end

end