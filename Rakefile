$:.unshift(File.dirname(__FILE__) + '/lib')
require 'rake'
require 'yaml'
require "rspec/core/rake_task"

require "tmdb_party/version"
task :build do
  system "gem build tmdb_party.gemspec"
end

desc "Run all examples"
RSpec::Core::RakeTask.new('spec') do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

RSpec::Core::RakeTask.new('rcov') do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "tmdb_party #{TMDBParty::VERSION}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
