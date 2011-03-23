module TMDBParty
  class CastMember < Entity
    attr_reader :tmdb
    attributes :name, :url, :job, :department
    attributes :id, :type => Integer
    
    def character_name
      read_attribute('character')
    end
    
    def image_url
      read_attribute('profile')
    end
    
    def person
      tmdb.get_person(id)
    end
  end
end
