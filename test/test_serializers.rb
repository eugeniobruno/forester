require 'minitest_helper'

class TestSerializers < Forester::Test
  def test_as_root_hash
    add_empty_children_keys(simple_tree_hash)

    expected = simple_tree_hash
    actual   = simple_tree.as_root_hash

    assert_equal expected, actual
  end

  def test_as_root_hash_with_max_depth
    expected = simple_tree_hash.tap { |h| h['children'] = [] }
    actual   = simple_tree.as_root_hash(max_depth: 0)

    assert_equal expected, actual
  end

  def test_as_root_hash_with_max_depth_and_symbolized_keys
    expected = pruned_simple_tree_hash
    actual = simple_tree.as_root_hash(max_depth: 1, symbolize_keys: true)

    assert_equal expected, actual
  end

  def test_as_root_hash_with_included_fields
    expected = pruned_simple_tree_hash_with_names_and_values_only
    actual = simple_tree.as_root_hash({
      max_depth: 1,
      symbolize_keys: true,
      include_fields: [:name, :value]
    })

    assert_equal expected, actual
  end

  def test_as_root_hash_with_excluded_fields
    expected = pruned_simple_tree_hash_without_names_and_values
    actual = simple_tree.as_root_hash({
      max_depth: 1,
      symbolize_keys: true,
      exclude_fields: [:name, :value]
    })

    assert_equal expected, actual
  end

  private

  def add_empty_children_keys(hash)
    hash['children'] = hash.fetch('children', [])
    hash['children'].each { |child| add_empty_children_keys(child) }
  end

  def pruned_simple_tree_hash
    {
      name: 'root',
      value: 0,
      strings: ['This is the root'],
      children: [
        {
          name: 'First node of depth 1',
          value: 1,
          color: 'Green',
          tone: 'Dark',
          tags: [
            'First tag',
            'Second tag',
            'Third tag'
          ],
          children: []
        },
        {
          name: 'Second node of depth 1',
          value: 4,
          color: 'Green',
          tone: 'Dark',
          children: []
        }
      ]
    }
  end

  def pruned_simple_tree_hash_with_names_and_values_only
    {
      name: 'root',
      value: 0,
      children: [
        {
          name: 'First node of depth 1',
          value: 1,
          children: []
        },
        {
          name: 'Second node of depth 1',
          value: 4,
          children: []
        }
      ]
    }
  end

  def pruned_simple_tree_hash_without_names_and_values
    {
      strings: ['This is the root'],
      children: [
        {
          color: 'Green',
          tone: 'Dark',
          tags: [
            'First tag',
            'Second tag',
            'Third tag'
          ],
          children: []
        },
        {
          color: 'Green',
          tone: 'Dark',
          children: []
        }
      ]
    }
  end
end
