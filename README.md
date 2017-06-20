# Forester

[![Gem Version](https://badge.fury.io/rb/forester.svg)](https://badge.fury.io/rb/forester)
[![Build Status](https://travis-ci.org/eugeniobruno/forester.svg?branch=master)](https://travis-ci.org/eugeniobruno/forester)
[![Coverage Status](https://coveralls.io/repos/github/eugeniobruno/forester/badge.svg?branch=master)](https://coveralls.io/github/eugeniobruno/forester?branch=master)
[![Code Climate](https://codeclimate.com/github/eugeniobruno/forester.svg)](https://codeclimate.com/github/eugeniobruno/forester)
[![Dependency Status](https://gemnasium.com/eugeniobruno/forester.svg)](https://gemnasium.com/eugeniobruno/forester)

Based on *rubytree*, this gem lets you build trees and run queries against them.

## FAQ

- What's the difference between forester and rubytree?

The main class provided by the *rubytree* gem is **Tree::TreeNode**. In the case of forester, it is **Forester::TreeNode**, which is nothing more than a subclass of the former.

- Why is this a separate gem and not just a pull request in rubytree?

Because I needed to develop a certain feature on top of TreeNode in a time-sensitive manner. Rubytree devs should feel free to take anything they like from this project.

- Why is forester not a fork of rubytree?

Because I didn't feel the need to copy the whole codebase. All I needed was to extend the functionality of a class.

- What can I do with forester?

Everything you can do with rubytree, possibly in a more intention-revealing way, plus some configurable aggregations on trees. Simple examples can be found in the tests.

## Installation

Add this line to your application's Gemfile:

    gem 'forester'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install forester

## Usage

Build your tree with any of the factory methods in TreeFactory, and then start messaging the resulting instance of TreeNode.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
