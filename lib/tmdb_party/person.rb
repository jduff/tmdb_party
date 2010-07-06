module TMDBParty
  class Person
    include Attributes
    attr_reader :tmdb
    attributes :id, :popularity, :type => Integer
    attributes :score, :type => Float
    attributes :name, :url, :biography
    
    attributes :birthplace, :birthday, :lazy => :get_info!
    
    def initialize(values, tmdb)
      @tmdb = tmdb
      self.attributes = values
    end
    
    def biography
      # HTTParty does not parse the encoded hexadecimal properly. It does not consider 000F to be a hex, but 000f is
      # A bug has been submitted about this
      read_attribute('biography').gsub("\\n", "\n").gsub(/\\u([0-9A-F]{4})/) { [$1.hex].pack("U") }
    end
    
    
    def get_info!
      person = tmdb.get_person(self.id)
      @attributes.merge!(person.attributes) if person
      @loaded = true
    end
  end
end