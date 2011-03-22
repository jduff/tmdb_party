module TMDBParty
  class Genre
    include Attributes
    attributes :id, :type => Integer
    attributes :name, :url
    
    def initialize(values, klass=nil)
      self.attributes = values
    end
    
    def self.parse(data)
      return unless data
      if data.is_a?(Array)
        data.collect do |g|
          Genre.new(g)
        end
      else
        [Genre.new(data)]
      end
    end
  end
end
