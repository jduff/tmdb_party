module TMDBParty
  class Person
    include Attributes
    attr_reader :tmdb
    attributes :id, :type => Integer
    attributes :name, :url
    
    attributes :birthplace, :birthday, :lazy => :get_info!
    
    def initialize(values, tmdb)
      @tmdb = tmdb
      self.attributes = values
    end
    
    def get_info!
      person = tmdb.get_person(self.id)
      @attributes.merge!(person.attributes) if person
      @loaded = true
    end
  end
end