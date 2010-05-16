module TMDBParty
  class Person
    include Attributes
    attributes :name, :character, :url, :profile, :job
    attributes :id, :type => Integer
    
    alias_method :character_name, :character
    alias_method :image_url, :profile
    
    def initialize(values)
      self.attributes = values
    end
    
    def self.parse(data)
      return unless data
      if data.is_a?(Array)
        data.collect do |person|
          Person.new(person)
        end
      else
        [Person.new(data)]
      end
    end
  end
end