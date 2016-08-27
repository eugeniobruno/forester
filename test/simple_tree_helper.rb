module SimpleTreeHelper
  PATH_TO_TREES       = "#{File.dirname(__FILE__)}/trees"
  PATH_TO_SIMPLE_TREE = "#{PATH_TO_TREES}/simple_tree.yml"
  @@tree = Forester::TreeFactory.from_yaml_file(PATH_TO_SIMPLE_TREE)
end
