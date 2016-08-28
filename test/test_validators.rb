require 'minitest/autorun'
require 'forester'

require_relative './simple_tree_helper'

class TestValidators < Minitest::Test

  include SimpleTreeHelper

  def test_validate_uniqueness_of_field_uniques
    expected = {
      is_valid: true,
      repeated: {},
      failures: {}
    }

    ['name', :name, 'special', 'ghost'].each do |field|
      actual = @@tree.validate_uniqueness_of_field(field)
      assert_equal expected, actual
    end

  end

  def test_validate_uniqueness_of_field_color
    expected = {
      is_valid: false,
      repeated: {
        :color => ['Green', 'Yellow']
        },
      failures: {
        :color => {
          'Green'  => ['First node of level 1', 'Second node of level 1'],
          'Yellow' => ['First node of level 4', 'Second node of level 4']
        }
      }
    }

    actual = @@tree.validate_uniqueness_of_field(:color)
    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_field_color_first_failure_only
    expected = {
      is_valid: false,
      repeated: {
        :color => ['Green']
        },
      failures: {
        :color => {
          'Green'  => ['First node of level 1', 'Second node of level 1']
        }
      }
    }

    actual = @@tree.validate_uniqueness_of_field(:color, {
      first_failure_only: true
    })
    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_field_color_among_siblings_of_level_1
    expected = {
      is_valid: false,
      repeated: {
        :color => ['Green']
        },
      failures: {
        :color => {
          'Green' => ['First node of level 1', 'Second node of level 1']
        }
      }
    }

    actual = @@tree.validate_uniqueness_of_field(:color, {
      among_siblings_of_level: 1
    })

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_field_color_among_siblings_of_level_2
    expected = {
      is_valid: true,
      repeated: {},
      failures: {}
    }

    actual = @@tree.validate_uniqueness_of_field(:color, {
      among_siblings_of_level: 2
    })

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_field_color_within_subtrees_of_level_1
    expected = {
      is_valid: false,
      repeated: {
        :color => ['Yellow']
        },
      failures: {
        :color => {
          'Yellow' => ['First node of level 4', 'Second node of level 4']
        }
      }
    }

    actual = @@tree.validate_uniqueness_of_field(:color, {
      within_subtrees_of_level: 1,
    })

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_field_color_within_subtrees_of_level_3
    expected = {
      is_valid: false,
      repeated: {
        :color => ['Yellow']
        },
      failures: {
        :color => {
          'Yellow' => ['First node of level 4', 'Second node of level 4']
        }
      }
    }

    actual = @@tree.validate_uniqueness_of_field(:color, {
      within_subtrees_of_level: 3,
    })

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_field_color_within_subtrees_of_level_4
    expected = {
      is_valid: true,
      repeated: {},
      failures: {}
    }

    actual = @@tree.validate_uniqueness_of_field(:color, {
      within_subtrees_of_level: 4,
    })

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_fields_name_color
    expected = {
      is_valid: false,
      repeated: {
        'color' => ['Green', 'Yellow']
        },
      failures: {
        'color' => {
          'Green'  => ['First node of level 1', 'Second node of level 1'],
          'Yellow' => ['First node of level 4', 'Second node of level 4']
        }
      }
    }

    actual = @@tree.validate_uniqueness_of_fields(['name', 'color'])

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_combination_of_fields_name_color
    expected = {
      is_valid: true,
      repeated: {},
      failures: {}
    }

    actual = @@tree.validate_uniqueness_of_fields(['name', 'color'], {
      combination: true
    })

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_fields_color_tone_first_failure_only
    expected = {
      is_valid: false,
      repeated: {
        'color' => ['Green']
        },
      failures: {
        'color' => {
          'Green' => ['First node of level 1', 'Second node of level 1']
        }
      }
    }

    actual = @@tree.validate_uniqueness_of_fields(['color', 'tone'], {
      first_failure_only: true
    })

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_fields_color_tone
    expected = {
      is_valid: false,
      repeated: {
        'color' => ['Green', 'Yellow'],
        'tone'  => ['Dark']
        },
      failures: {
        'color' => {
          'Green'  => ['First node of level 1', 'Second node of level 1'],
          'Yellow' => ['First node of level 4', 'Second node of level 4']
        },
        'tone' => {
          'Dark' => ['First node of level 1', 'Second node of level 1']
        }
      }
    }

    actual = @@tree.validate_uniqueness_of_fields(['color', 'tone'])

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_combination_of_fields_color_tone
    expected = {
      is_valid: false,
      repeated: {
        ['color', 'tone'] => [['Green', 'Dark']]
        },
      failures: {
        ['color', 'tone'] => {
          ['Green', 'Dark'] => ['First node of level 1', 'Second node of level 1']
        }
      }
    }

    actual = @@tree.validate_uniqueness_of_fields(['color', 'tone'], {
      combination: true
    })

    assert_equal expected, actual
  end

end
