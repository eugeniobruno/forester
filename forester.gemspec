# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'forester/version'

Gem::Specification.new do |s|
  s.name        = 'forester'
  s.version     = Forester::Version
  s.date        = '2017-05-01'
  s.summary     = "A trees library"
  s.description = "Forester is a collection of utilities to represent and interact with tree data structures."
  s.authors     = "Eugenio Bruno"
  s.email       = 'eugeniobruno@gmail.com'
  s.homepage    = 'https://github.com/eugeniobruno/forester'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.0.0'

  s.add_runtime_dependency 'rubytree', '0.9.7'

  s.add_development_dependency 'bundler', '~> 1.15'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'minitest-bender', '~> 0.0'
  s.add_development_dependency 'simplecov', '~> 0.14'
  s.add_development_dependency 'coveralls', '~> 0.8'
  s.add_development_dependency 'pry-byebug', '~> 3.4'
end
