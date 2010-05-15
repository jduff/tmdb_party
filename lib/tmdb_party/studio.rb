module TMDBParty
  class Studio
    include Attributes
    attributes :name, :url
    
    def self.parse(data)
      return unless data
      if data.is_a?(Array)
        data.map { |row| Studio.new(row) }
      else
        [Studio.new(data)]
      end
    end
    
    def initialize(attributes)
      self.attributes = attributes
    end
  end
end