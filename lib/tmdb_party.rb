gem 'httparty'
require 'httparty'
require 'tmdb_party/core_extensions'
require 'tmdb_party/attributes'
require 'tmdb_party/video'
require 'tmdb_party/category'
require 'tmdb_party/image'
require 'tmdb_party/movie'

module TMDBParty
  class Base
    include HTTParty
    base_uri 'http://api.themoviedb.org/2.0'
    format :xml
    
    def initialize(key)
      self.class.default_params :api_key => key
    end
    
    def search(query)
      data = self.class.get('/Movie.search', :query=>{:title=>query})
      data['results']['moviematches']['movie'].collect do |movie|
        Movie.new(movie, self)
      end
    end
    
    def imdb_lookup(id)
    end
    
    def get_info(id)
      data = self.class.get('/Movie.getInfo', :query=>{:id=>id})
      Movie.new(data['results']['moviematches']['movie'], self)
    end
  end
end