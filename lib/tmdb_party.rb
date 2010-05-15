# gem 'httparty'
require 'httparty'
require 'tmdb_party/core_extensions'
require 'tmdb_party/httparty_icebox'
require 'tmdb_party/attributes'
require 'tmdb_party/video'
require 'tmdb_party/genre'
require 'tmdb_party/person'
require 'tmdb_party/image'
require 'tmdb_party/country'
require 'tmdb_party/studio'
require 'tmdb_party/movie'

module TMDBParty
  class Base
    include HTTParty
    include HTTParty::Icebox
    cache :store => 'file', :timeout => 120, :location => Dir.tmpdir

    base_uri 'http://api.themoviedb.org/2.1'
    format :json
    
    def initialize(key)
      @api_key = key
    end
    
    def default_path_items
      path_items = ['en']
      path_items << 'json'
      path_items << @api_key
    end
    
    def search(query)
      data = self.class.get("/Movie.search/" + default_path_items.join('/') + '/' + URI.escape(query))
      if data.class != Array || data.first == "Nothing found."
        []
      else
        data.collect { |movie| Movie.new(movie, self) }
      end
    end
    
    def imdb_lookup(imdb_id)
      data = self.class.get("/Movie.imdbLookup/" + default_path_items.join('/') + '/' + imdb_id)
      if data.class != Array || data.first == "Nothing found."
        nil
      else
        Movie.new(data.first, self)
      end
    end
    
    def get_info(id)
      data = self.class.get("/Movie.getInfo/" + default_path_items.join('/') + '/' + id.to_s)
      Movie.new(data.first, self)
    end
  end
end