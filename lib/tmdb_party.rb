lib = File.expand_path('../', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bundler/setup'
require 'httparty'

%w[extras/object_extensions extras/httparty_icebox extras/attributes version entity video genre person image country studio cast_member movie extras/movie_hasher].each do |class_name|
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
      handle_response(Movie, 'Movie.search', lang, query)
    end

    # Read more about the parameters that can be passed to this method here:
    # http://api.themoviedb.org/2.1/methods/Movie.browse
    def browse(params = {}, lang = @default_lang)
      handle_response(Movie, 'Movie.browse', lang, :query => {:order => "asc", :order_by => "title"}.merge(params))
    end
    
    def search_person(query, lang = @default_lang)
      handle_response(Person, 'Person.search', lang, query)
    end
    
    def imdb_lookup(imdb_id, lang = @default_lang)
      handle_response(Movie, 'Movie.imdbLookup', lang, imdb_id).first
    end
    
    def get_info(id, lang = @default_lang)
      handle_response(Movie, 'Movie.getInfo', lang, id).first
    end

    def get_file_info(file, lang=@default_lang)
      hash     = TMDBParty::MovieHasher.compute_hash(file)
      bytesize = file.size
      handle_response(Movie, 'Media.getInfo', lang, hash, bytesize)
    end

    def get_person(id, lang = @default_lang)
      handle_response(Person, 'Person.getInfo', lang, id).first
    end
    
    def get_genres(lang = @default_lang)
      handle_response(Genre, 'Genres.getList', lang)[1..-1]
    end
    
    private
    def handle_response klass, api_method, *args
      # Custom sorting, etc to send to HTTParty
      query_opts  = args.pop if args[-1].is_a?(Hash)

      #Language, id, etc for URL construction
      lang, *rest = args

      url         = method_url(api_method, lang, rest)
      data        = self.class.get(url, query_opts || {}).parsed_response

      result_or_empty_array data, klass
    end

    def result_or_empty_array(data, klass)
      if data.class != Array || data.first == "Nothing found."
        []
      else
        data.collect { |object| klass.new(object, self) }
      end
    end

    def method_url(method, lang, *args)
      url = [method, lang, self.class.format, @api_key]
      args.flatten!
      url += args.collect{ |a| URI.escape(a.to_s) }
      '/' + url.join('/')
    end
  end
end
