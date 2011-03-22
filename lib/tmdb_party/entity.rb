module TMDBParty
  class Entity
    include Attributes
    def initialize(values, tmdb=nil)
      @tmdb = tmdb
      self.attributes = values
    end

    def self.parse(data, tmdb=nil)
      return unless data
      if data.is_a?(Array)
        data.collect do |person|
          self.new(person, tmdb)
        end
      else
        [self.new(data, tmdb)]
      end
    end
  end
end
