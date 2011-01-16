require 'rubygems'
require 'rake'
require 'yaml'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "tmdb_party"
    gem.summary = %Q{Simple ruby wrapper to themoviedb.org (http://api.themoviedb.org/2.0/docs/) using HTTParty}
    gem.email = "duff.john@gmail.com"
    gem.homepage = "http://github.com/jduff/tmdb_party"
    gem.authors = ["John Duff", "Jon Maddox"]
    gem.add_dependency('httparty', '>= 0.6.1')
    
    gem.add_development_dependency('fakeweb')
    gem.add_development_dependency('rspec')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
desc "Run all examples"
Spec::Rake::SpecTask.new('spec') do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

Spec::Rake::SpecTask.new('rcov') do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "tmdb_party #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
