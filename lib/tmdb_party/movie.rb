module TMDBParty
  class Movie
    include Attributes
    attr_reader :tmdb
    
    attributes :name, :overview, :id, :imdb_id, :movie_type, :url, :alternative_title, :translated, :certification
    attributes :released
    attributes :id, :popularity, :type => Integer
    attributes :score, :type => Float
    
    attributes :tagline, :lazy => :get_info!
    attributes :posters, :backdrops, :lazy => :get_info!, :type => Image
    attributes :homepage, :lazy => :get_info!
    attributes :trailer, :lazy => :get_info!
    attributes :runtime, :lazy => :get_info!, :type => Integer
    attributes :genres, :lazy => :get_info!, :type => Genre
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

    def cast
      # TODO: This needs refactoring
      CastMember.parse(read_or_load_attribute('cast', nil, :get_info!), tmdb)
    end

    def language
      read_attribute('language').downcase.to_sym
    end

    def last_modified_at
      # Date from TMDB is always in MST, but no timezone is present in date string
      Time.parse(read_attribute('last_modified_at') + ' MST')
    end

    def directors
      find_cast('Directing')
    end

    def actors
      find_cast('Actors')
    end

    def writers
      find_cast('Writing')
    end

    def producers
      find_cast('Production')
    end
    
    private
    
    def find_cast(type)
      return [] unless cast
      guys = cast.select{|c| c.department == type}
    end

  end
  
end