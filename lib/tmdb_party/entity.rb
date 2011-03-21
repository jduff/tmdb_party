module TMDBParty
  class Entity
    include Attributes
    
    def self.parse(data)
      return unless data
      if data.is_a?(Array)
        data.map { |row| self.new(row) }
      else
        [self.new(data)]
      end
    end
    
    def initialize(attributes)
      self.attributes = attributes
    end
  end
end
