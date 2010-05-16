module TMDBParty
  class Movie
    include Attributes
    attr_reader :tmdb
    
    attributes :name, :overview, :id, :score, :imdb_id, :movie_type, :url, :popularity, :alternative_title, :translated, :certification
    attributes :released
    attributes :id, :type => Integer
    attributes :popularity, :score, :type => Float
    
    attributes :tagline, :lazy => :get_info!
    attributes :posters, :backdrops, :lazy => :get_info!, :type => Image
    attributes :homepage, :lazy => :get_info!
    attributes :trailer, :lazy => :get_info!
    attributes :runtime, :lazy => :get_info!, :type => Integer
    attributes :genres, :lazy => :get_info!, :type => Genre
    attributes :cast, :lazy => :get_info!, :type => Person
    attributes :countries, :lazy => :get_info!, :type => Country
    attributes :studios, :lazy => :get_info!, :type => Studio
    
    alias_method :translated?, :translated
    
    def initialize(values, tmdb)
      @tmdb = tmdb
      self.attributes = values
    end
    
    def get_info!
      movie = tmdb.get_info(self.id)
      @attributes.merge!(movie.attributes) if movie
      @loaded = true
    end

    def language
      read_attribute('language').downcase.to_sym
    end

    def last_modified_at
      # Date from TMDB is always in MST, but no timezone is present in date string
      Time.parse(read_attribute('last_modified_at') + ' MST')
    end

    def directors
      find_cast('Director')
    end

    def actors
      find_cast('Actor')
    end

    def writers
      find_cast('Writer')
    end
    
    private
    
    def find_cast(type)
      return [] unless cast
      guys = cast.select{|c| c.job == type}
    end

  end
  
end