# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'forester/version'

Gem::Specification.new do |s|
  s.name        = 'forester'
  s.version     = Forester::Version
  s.date        = '2016-08-22'
  s.summary     = "A gem to represent and interact with tree data structures"
  s.description = "Based on rubytree, this gem lets you build trees and run queries against them."
  s.authors     = ["Eugenio Bruno"]
  s.email       = 'eugeniobruno@gmail.com'
  s.homepage    = 'http://rubygems.org/gems/forester'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.0.0'

  s.add_runtime_dependency 'rubytree', ['0.9.7']

  s.add_development_dependency 'rake', ['~> 11.2']
  s.add_development_dependency 'minitest', ['~> 5.9']
  s.add_development_dependency 'pry-byebug', ['~> 3.4']

end