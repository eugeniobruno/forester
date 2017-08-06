# Forester

[![Gem Version](https://badge.fury.io/rb/forester.svg)](https://badge.fury.io/rb/forester)
[![Build Status](https://travis-ci.org/eugeniobruno/forester.svg?branch=master)](https://travis-ci.org/eugeniobruno/forester)
[![Coverage Status](https://coveralls.io/repos/github/eugeniobruno/forester/badge.svg?branch=master)](https://coveralls.io/github/eugeniobruno/forester?branch=master)
[![Code Climate](https://codeclimate.com/github/eugeniobruno/forester.svg)](https://codeclimate.com/github/eugeniobruno/forester)
[![Dependency Status](https://gemnasium.com/eugeniobruno/forester.svg)](https://gemnasium.com/eugeniobruno/forester)

Forester's functionality is a superset of [RubyTree](https://github.com/evolve75/RubyTree)'s that further facilitates the work with tree data structures at the right level of abstraction.

## Installation

Add this line to your application's Gemfile:

    gem 'forester'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install forester

## Usage

Here is a simple example:

```ruby
serialized_tree = {
  label: 'anything',
  count: 0,
  children: [
    {
      label: 'first child',
      count: 1,
      children: [
        {
          label: 'first grandchild',
          count: 3
        }
      ]
    },
    {
      label: 'second child',
      count: 2
    }
  ]
}

# Any node can have any set of fields

tree = Forester.tree_factory.from_root_hash(serialized_tree, children_key: :children)

all_counts = tree.each_node(traversal: :breadth_first).map { |n| n.get(:count) }
# [0, 1, 2, 3]

tree.add_child_content(label: 'third child')

tree.validate_uniqueness_of_field(:label)
# { is_valid: true, repeated: {}, failures: {} }

tree.as_root_hash
# a hash with the same structure as serialized_tree
```

The full set of utilities are covered with unit tests, which also serve as usage examples.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eugeniobruno/forester. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


