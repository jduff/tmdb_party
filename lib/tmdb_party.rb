require 'httparty'

%w[extras/httparty_icebox extras/attributes entity video genre person image country studio cast_member movie extras/movie_hasher].each do |class_name|
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
      data = self.class.get(method_url('Movie.search', lang, query))
      
      result_or_empty_array(data, Movie)
    end

    # Read more about the parameters that can be passed to this method here:
    # http://api.themoviedb.org/2.1/methods/Movie.browse
    def browse(params = {}, lang = @default_lang)
      data = self.class.get(method_url('Movie.browse', lang), :query => {:order => "asc", :order_by => "title"}.merge(params))
      
      result_or_empty_array(data, Movie)
    end
    
    def search_person(query, lang = @default_lang)
      data = self.class.get(method_url('Person.search', lang, query))
      
      result_or_empty_array(data, Person)
    end
    
    def imdb_lookup(imdb_id, lang = @default_lang)
      data = self.class.get(method_url('Movie.imdbLookup', lang, imdb_id)).parsed_response
      if data.class != Array || data.first == "Nothing found."
        nil
      else
        Movie.new(data.first, self)
      end
    end
    
    def get_info(id, lang = @default_lang)
      data = self.class.get(method_url('Movie.getInfo', lang, id)).parsed_response
      Movie.new(data.first, self)
    end

    def get_file_info(file, lang=@default_lang)
      hash = TMDBParty::MovieHasher.compute_hash(file)
      bytesize = file.size
      data = self.class.get(method_url('Media.getInfo', lang, hash, bytesize))

      result_or_empty_array(data, Movie)
    end

    def get_person(id, lang = @default_lang)
      data = self.class.get(method_url('Person.getInfo', lang, id)).parsed_response
      Person.new(data.first, self)
    end
    
    def get_genres(lang = @default_lang)
      data = self.class.get(method_url('Genres.getList', lang)).parsed_response
      data[1..-1].collect { |genre| Genre.new(genre) } # Skips the first, see spec/fixtures/genres_results.json
    end
    
    private

    def result_or_empty_array(data, klass)
      data = data.parsed_response
      if data.class != Array || data.first == "Nothing found."
        []
      else
        data.collect { |object| klass.new(object, self) }
      end
    end

    def method_url(method, lang, *args)
      url = [method, lang, self.class.format, @api_key]
      url += args.collect{ |a| URI.escape(a.to_s) }
      '/' + url.join('/')
    end
  end
end
