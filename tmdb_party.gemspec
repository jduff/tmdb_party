# -*- encoding: utf-8 -*-
$:.unshift(File.dirname(__FILE__) + '/lib')

require 'tmdb_party/version'

Gem::Specification.new do |s|
  s.name        = "tmdb_party"
  s.version     = TMDBParty::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Duff", "Jon Maddox", "Ash McKenzie"]
  s.email       = ["duff.john@gmail.com"]
  s.homepage    = "https://github.com/jduff/tmdb_party"
  s.summary     = %q{Simple ruby wrapper to themoviedb.org}
  s.description = %q{Simple ruby wrapper to themoviedb.org (http://api.themoviedb.org/2.0/docs/) using HTTParty}

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "tmdb_party"

  s.add_dependency "httparty", "~> 0.7.8"
  s.add_development_dependency "rake"
  s.add_development_dependency "fakeweb"
  s.add_development_dependency "rcov"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "rspec", ">= 2.8.0"
  s.add_development_dependency "pry"

  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths      = ["lib"]
end
