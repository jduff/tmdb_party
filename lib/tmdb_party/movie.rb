module TMDBParty
  class Movie
    include Attributes
    attr_reader :tmdb
    
    attributes :title, :short_overview, :id, :score, :imdb, :type, :url, :popularity, :alternative_title
    attributes :release, :type=>DateTime
    attributes :id, :runtime, :type => Integer
    attributes :popularity, :score, :type => Float
    attributes :poster, :backdrop, :type => Image
    
    attributes :homepage, :lazy => :get_info!
    attributes :trailer, :lazy => :get_info!, :type=> Video
    attributes :categories, :lazy => :get_info!, :type=> Category
    attributes :people, :lazy => :get_info!, :type=> Person
    
    def initialize(values, tmdb)
      @tmdb = tmdb
      self.attributes = values
    end
    
    def get_info!
      movie = tmdb.get_info(self.id)
      @attributes.merge!(movie.attributes) if movie
      @loaded = true
    end

    def directors
      people.select{|p| p.job == 'director'}
    end

    def actors
      people.select{|p| p.job == 'actor'}
    end

    def writers
      people.select{|p| p.job == 'writer'}
    end

  end
  
end