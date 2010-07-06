module TMDBParty
  class Country
    include Attributes
    attributes :name, :code, :url
    alias_method :code_string, :code
    
    def self.parse(data)
      return unless data
      if data.is_a?(Array)
        data.map { |row| Country.new(row) }
      else
        [Country.new(data)]
      end
    end
    
    def initialize(attributes)
      self.attributes = attributes
    end
    
    def code
      code_string.downcase.to_sym
    end
    
  end
end