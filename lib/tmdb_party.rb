# gem 'httparty'
require 'httparty'
require 'tmdb_party/core_extensions'
require 'tmdb_party/httparty_icebox'
require 'tmdb_party/attributes'
require 'tmdb_party/video'
require 'tmdb_party/category'
require 'tmdb_party/person'
require 'tmdb_party/image'
require 'tmdb_party/movie'

module TMDBParty
  class Base
    include HTTParty
    include HTTParty::Icebox
    cache :store => 'file', :timeout => 120, :location => Dir.tmpdir

    base_uri 'http://api.themoviedb.org/2.0'
    format :xml
    
    def initialize(key)
      self.class.default_params :api_key => key
    end
    
    def search(query)
      data = self.class.get('/Movie.search', :query=>{:title=>query})
      
      case data['results']['moviematches']['movie']
      when Array
        data['results']['moviematches']['movie'].collect { |movie| Movie.new(movie, self) }
      when Hash
        [Movie.new(data['results']['moviematches']['movie'], self)]
      else
        []
      end
    end
    
    def imdb_lookup(imdb_id)
      data = self.class.get('/Movie.imdbLookup', :query=>{:imdb_id=>imdb_id})
      case data['results']['moviematches']['movie']
      when String
        return nil
      when Hash
        Movie.new(data['results']['moviematches']['movie'], self)
      end
    end
    
    def get_info(id)
      data = self.class.get('/Movie.getInfo', :query=>{:id=>id})
      Movie.new(data['results']['moviematches']['movie'], self)
    end
  end
end