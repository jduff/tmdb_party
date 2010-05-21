# gem 'httparty'
require 'httparty'

%w[core_extensions httparty_icebox attributes video genre person image country studio cast_member movie].each do |class_name|
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
      data = self.class.get(method_url('Movie.search', query))
      if data.class != Array || data.first == "Nothing found."
        []
      else
        data.collect { |movie| Movie.new(movie, self) }
      end
    end
    
    def search_person(query)
      data = self.class.get(method_url('Person.search', query))
      if data.class != Array || data.first == "Nothing found."
        []
      else
        data.collect { |person| Person.new(person) }
      end
    end
    
    def imdb_lookup(imdb_id)
      data = self.class.get(method_url('Movie.imdbLookup', imdb_id))
      if data.class != Array || data.first == "Nothing found."
        nil
      else
        Movie.new(data.first, self)
      end
    end
    
    def get_info(id)
      data = self.class.get(method_url('Movie.getInfo', id))
      Movie.new(data.first, self)
    end
    
    private
      def default_path_items
        [@lang, 'json', @api_key]
      end
      
      def method_url(method, value)
        '/' + ([method] + default_path_items + [URI.escape(value.to_s)]).join('/')
      end
  end
end