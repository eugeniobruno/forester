require 'minitest_helper'

class TestValidators < Forester::Test

  def test_validate_uniqueness_of_field_uniques
    expected = {
      is_valid: true,
      repeated: {},
      failures: {}
    }

    ['name', :name, 'special', 'ghost'].each do |field|
      actual = validate_uniqueness_of_field(field)
      assert_equal expected, actual
    end
  end

  def test_validate_uniqueness_of_field_color
    expected = {
      is_valid: false,
      repeated: {
        'color' => ['Green', 'Yellow']
        },
      failures: {
        'color' => {
          'Green'  => ['First node of depth 1', 'Second node of depth 1'],
          'Yellow' => ['First node of depth 4', 'Second node of depth 4']
        }
      }
    }

    actual = validate_uniqueness_of_field('color')
    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_field_color_first_failure_only1
    expected = {
      is_valid: false,
      repeated: {
        'color' => ['Green']
        },
      failures: {
        'color' => {
          'Green'  => ['First node of depth 1', 'Second node of depth 1']
        }
      }
    }

    actual = validate_uniqueness_of_field('color', {
      first_failure_only: true
    })
    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_field_color_first_failure_only2
    expected = {
      is_valid: false,
      repeated: {
        'color' => ['Green']
        },
      failures: {
        'color' => {
          'Green'  => ['First node of depth 1', 'Second node of depth 1']
        }
      }
    }

    actual = simple_tree.validate_uniqueness_of_field('color', {
      first_failure_only: true
    })

    actual[:failures]['color']['Green'] = actual[:failures]['color']['Green'].map do |node|
      node.get('name')
    end

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_field_color_among_siblings_of_depth_1
    expected = {
      is_valid: false,
      repeated: {
        'color' => ['Green']
        },
      failures: {
        'color' => {
          'Green' => ['First node of depth 1', 'Second node of depth 1']
        }
      }
    }

    actual = validate_uniqueness_of_field('color', {
      among_siblings_of_depth: 1
    })

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_field_color_among_siblings_of_depth_2
    expected = {
      is_valid: true,
      repeated: {},
      failures: {}
    }

    actual = validate_uniqueness_of_field('color', {
      among_siblings_of_depth: 2
    })

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_field_color_within_subtrees_of_depth_1
    expected = {
      is_valid: false,
      repeated: {
        'color' => ['Yellow']
        },
      failures: {
        'color' => {
          'Yellow' => ['First node of depth 4', 'Second node of depth 4']
        }
      }
    }

    actual = validate_uniqueness_of_field('color', {
      within_subtrees_of_depth: 1,
    })

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_field_color_within_subtrees_of_depth_3
    expected = {
      is_valid: false,
      repeated: {
        'color' => ['Yellow']
        },
      failures: {
        'color' => {
          'Yellow' => ['First node of depth 4', 'Second node of depth 4']
        }
      }
    }

    actual = validate_uniqueness_of_field('color', {
      within_subtrees_of_depth: 3,
    })

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_field_color_within_subtrees_of_depth_4
    expected = {
      is_valid: true,
      repeated: {},
      failures: {}
    }

    actual = validate_uniqueness_of_field('color', {
      within_subtrees_of_depth: 4,
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
          'Green'  => ['First node of depth 1', 'Second node of depth 1'],
          'Yellow' => ['First node of depth 4', 'Second node of depth 4']
        }
      }
    }

    actual = validate_uniqueness_of_fields(['name', 'color'])

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_fields_combination_name_color
    expected = {
      is_valid: true,
      repeated: {},
      failures: {}
    }

    actual = validate_uniqueness_of_fields_combination(['name', 'color'])

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_fields_combination_name_color_among_siblings
    expected = {
      is_valid: true,
      repeated: {},
      failures: {}
    }

    actual = validate_uniqueness_of_fields_combination(['name', 'color'], {
      among_siblings_of_depth: 2
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
          'Green' => ['First node of depth 1', 'Second node of depth 1']
        }
      }
    }

    actual = validate_uniqueness_of_fields(['color', 'tone'], {
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
          'Green'  => ['First node of depth 1', 'Second node of depth 1'],
          'Yellow' => ['First node of depth 4', 'Second node of depth 4']
        },
        'tone' => {
          'Dark' => ['First node of depth 1', 'Second node of depth 1']
        }
      }
    }

    actual = validate_uniqueness_of_fields(['color', 'tone'])

    assert_equal expected, actual
  end

  def test_validate_uniqueness_of_fields_combination_color_tone
    expected = {
      is_valid: false,
      repeated: {
        ['color', 'tone'] => [['Green', 'Dark']]
        },
      failures: {
        ['color', 'tone'] => {
          ['Green', 'Dark'] => ['First node of depth 1', 'Second node of depth 1']
        }
      }
    }

    actual = validate_uniqueness_of_fields_combination(['color', 'tone'])

    assert_equal expected, actual
  end

  private

  def validate_uniqueness_of_field(field, options = {})
    simple_tree.validate_uniqueness_of_field(field, validator_options.merge(options))
  end

  def validate_uniqueness_of_fields(fields, options = {})
    simple_tree.validate_uniqueness_of_fields(fields, validator_options.merge(options))
  end

  def validate_uniqueness_of_fields_combination(fields, options = {})
    simple_tree.validate_uniqueness_of_fields_combination(fields, validator_options.merge(options))
  end

  def validator_options
    {
      as_failure: ->(node) { node.get('name') }
    }
  end

end
