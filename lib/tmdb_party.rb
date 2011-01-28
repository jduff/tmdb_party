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
      @default_lang = lang
    end
    
    def search(query, lang = @default_lang)
      data = self.class.get(method_url('Movie.search', query, lang)).parsed_response
      if data.class != Array || data.first == "Nothing found."
        []
      else
        data.collect { |movie| Movie.new(movie, self) }
      end
    end
    
    def search_person(query, lang = @default_lang)
      data = self.class.get(method_url('Person.search', query, lang)).parsed_response
      if data.class != Array || data.first == "Nothing found."
        []
      else
        data.collect { |person| Person.new(person, self) }
      end
    end
    
    def imdb_lookup(imdb_id, lang = @default_lang)
      data = self.class.get(method_url('Movie.imdbLookup', imdb_id, lang)).parsed_response
      if data.class != Array || data.first == "Nothing found."
        nil
      else
        Movie.new(data.first, self)
      end
    end
    
    def get_info(id, lang = @default_lang)
      data = self.class.get(method_url('Movie.getInfo', id, lang)).parsed_response
      Movie.new(data.first, self)
    end
    
    def get_person(id, lang = @default_lang)
      data = self.class.get(method_url('Person.getInfo', id, lang)).parsed_response
      Person.new(data.first, self)
    end
    
    def get_genres(lang = @default_lang)
      data = self.class.get(method_url('Genres.getList', nil, lang)).parsed_response
      data[1..-1].collect { |genre| Genre.new(genre) } # Skips the first, see spec/fixtures/genres_results.json
    end
    
    private
      def default_path_items
        ['json', @api_key]
      end
      
      def method_url(method, value, lang)
        url = [method, lang, default_path_items]
        url << URI.escape(value.to_s) if value
        '/' + url.join('/')
      end
  end
end
