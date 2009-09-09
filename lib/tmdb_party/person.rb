module TMDBParty
  class Person
    include Attributes
    attributes :name, :url, :job
    
    def initialize(values)
      self.attributes = values
    end
    
    def self.parse(data)
      data = data["person"]
      if data.is_a?(Array)
        data.collect do |person|
          Person.new(person)
        end
      else
        Person.new(data)
      end
    end
  end
end