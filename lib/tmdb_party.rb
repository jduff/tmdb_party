# gem 'httparty'
require 'httparty'

%w[core_extensions httparty_icebox attributes video genre person image country studio movie].each do |class_name|
  require "tmdb_party/#{class_name}"
end

module TMDBParty
  class Base
    include HTTParty
    include HTTParty::Icebox
    cache :store => 'file', :timeout => 120, :location => Dir.tmpdir

    base_uri 'http://api.themoviedb.org/2.1'
    format :json
    
    def initialize(key, lang = 'en')
      @api_key = key
      @lang = lang
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
    
    private
      def default_path_items
        [@lang, 'json', @api_key]
      end
  end
end