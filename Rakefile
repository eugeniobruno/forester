require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = "test/**/test_*.rb"
end

desc "Run tests"
task default: :test

desc 'Start a REPL session'
task :console do
  require 'forester'
  require 'pry'
  ARGV.clear
  Pry.start
end