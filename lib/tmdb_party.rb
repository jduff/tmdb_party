require 'httparty'

%w[extras/httparty_icebox extras/attributes entity video genre person image country studio cast_member movie extras/movie_hasher].each do |class_name|
  require "tmdb_party/#{class_name}"
end

module TMDBParty
  def TMDBParty.api_key
    @@api_key
  end

  def TMDBParty.api_key=(val)
    @@api_key = val
    TMDBParty.tmdb # set the default instance
    @@api_key
  end

  # Default instance
  def TMDBParty.tmdb
    return @tmdb if @tmdb
    if TMDBParty.api_key
      @tmdb = TMDBParty::Base.new TMDBParty.api_key
    end
  end
    
  class Base
    include HTTParty
    include HTTParty::Icebox
    cache :store => 'file', :timeout => 120, :location => Dir.tmpdir

    base_uri 'http://api.themoviedb.org/2.1'
    format :json

    def initialize(key, lang = 'en')
      @api_key = key
      @@api_key = @api_key
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
        Movie.new(data.first)
      end
    end
    
    def get_info(id, lang = @default_lang)
      data = reload id, "Movie.getInfo", lang
      Movie.new(data.first)
    end

    def get_file_info(file, lang=@default_lang)
      hash = TMDBParty::MovieHasher.compute_hash(file)
      bytesize = file.size
      data = self.class.get(method_url('Media.getInfo', lang, hash, bytesize))

      result_or_empty_array(data, Movie)
    end

    def get_person(id, lang = @default_lang)
      data = reload id, "Person.getInfo", lang
      Person.new(data.first)
    end
    
    def get_genres(lang = @default_lang)
      data = self.class.get(method_url('Genres.getList', lang)).parsed_response
      data[1..-1].collect { |genre| Genre.new(genre) } # Skips the first, see spec/fixtures/genres_results.json
    end
    
    private

    # Fetch info for a given entity (Movie, Person, etc)
    def reload id, route, lang = @default_lang
      self.class.get(method_url(route, lang, id)).parsed_response
    end

    def result_or_empty_array(data, klass)
      data = data.parsed_response
      if data.class != Array || data.first == "Nothing found."
        []
      else
        data.collect { |object| klass.new(object) }
      end
    end

    def method_url(method, lang, *args)
      url = [method, lang, self.class.format, TMDBParty.api_key]
      url += args.collect{ |a| URI.escape(a.to_s) }
      '/' + url.join('/')
    end
  end
end
