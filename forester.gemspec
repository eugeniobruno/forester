# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'forester/version'

Gem::Specification.new do |s|
  s.name        = 'forester'
  s.version     = Forester::Version
  s.date        = '2016-07-17'
  s.summary     = "A gem to represent and interact with tree data structures"
  s.description = "Based on rubytree and enzymator, this gem lets you build trees and run queries against them."
  s.authors     = ["Eugenio Bruno"]
  s.email       = 'eugeniobruno@gmail.com'
  s.homepage    = 'http://rubygems.org/gems/forester'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_runtime_dependency 'rubytree', ['~> 0.9']
  s.add_runtime_dependency 'enzymator', ['~> 0.0']

  s.add_development_dependency 'rake', ['~> 11.2']
  s.add_development_dependency 'minitest', ['~> 5.9']
  s.add_development_dependency 'pry-byebug', ['~> 3.4']

end