module TMDBParty
  class Movie < Entity
    lazy_callback :get_info!
    attributes :name, :overview, :id, :imdb_id, :movie_type, :url, :alternative_title, :translated, :certification, :released, :tagline, :homepage, :trailer
    attributes :id, :popularity, :type => Integer
    attributes :score, :type => Float
    
    attributes :posters, :backdrops, :type => Image
    attributes :runtime,  :type => Integer
    attributes :genres,   :type => Genre
    attributes :countries,:type => Country
    attributes :studios,  :type => Studio
    
    alias_method :translated?, :translated
    
    def get_info!
      movie = TMDBParty.tmdb.get_info(self.id)
      @attributes.merge!(movie.attributes) if movie
      @loaded = true
    end

    def cast
      # TODO: This needs refactoring
      CastMember.parse(read_or_load_attribute('cast', nil, :get_info!))
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
