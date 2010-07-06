module TMDBParty
  class CastMember
    include Attributes
    attr_reader :tmdb
    attributes :name, :url, :job
    attributes :id, :type => Integer
    
    def initialize(values, tmdb)
      @tmdb = tmdb
      self.attributes = values
    end
    
    def character_name
      read_attribute('character')
    end
    
    def image_url
      read_attribute('profile')
    end
    
    def person
      tmdb.get_person(id)
    end
    
    def self.parse(data, tmdb)
      return unless data
      if data.is_a?(Array)
        data.collect do |person|
          CastMember.new(person, tmdb)
        end
      else
        [CastMember.new(data, tmdb)]
      end
    end
  end
end