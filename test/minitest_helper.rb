require 'simplecov'
SimpleCov.start do
  add_filter 'test/'
end

require 'minitest/autorun'

require 'pry-byebug'

require 'forester'

class Forester::Test < Minitest::Test

  private

  PATH_TO_TREES       = "#{File.dirname(__FILE__)}/trees"
  PATH_TO_SIMPLE_TREE = "#{PATH_TO_TREES}/simple_tree.yml"
  TREE = Forester::TreeFactory.from_yaml_file(PATH_TO_SIMPLE_TREE)

  def tree
    TREE
  end

end